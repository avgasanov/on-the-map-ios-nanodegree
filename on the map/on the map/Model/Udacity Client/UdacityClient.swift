//
//  UdacityClient.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/21/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var accountId = ""
        static var studentInfo: PublicUserInfo?
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case studentPutLocation(objectId: String)
        case studentLocations(limit: Int? = nil, skip: Int? = nil, order: String? = nil, uniqueKey: String? = nil)
        case userInfo(userId: String)
        case signup
        case studentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .studentPutLocation(let objectId): return Endpoints.base + "/StudentLocation/\(objectId)"
            case .studentLocation: return Endpoints.base + "/StudentLocation"
            case .studentLocations(let limit, _, let order, _):
                if let limit = limit, let order = order {
                    return Endpoints.base + "/StudentLocation?limit=\(limit)&order=\(order)"
                } else {
                    return Endpoints.base + "/StudentLocations"
                }
            case .userInfo(let userId): return Endpoints.base + "/users/\(userId)"
            case .signup: return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // Helper function from lessons. Refactored
    class func taskForRequest<RequestType: Encodable, ResponseType: Decodable>(skipSecurity: Bool = true, method: String = "POST", url: URL, responseType: ResponseType.Type,  body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            debugPrint(data)
            if !skipSecurity {
                data = skipUdacitySecurity(data)
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    // Helper function from lessons. Refactored
    class func taskForRequestWithoutBody<ResponseType: Decodable>(skipSecurity: Bool = true, method: String = "POST", url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if !skipSecurity {
                data = skipUdacitySecurity(data)
            }
            debugPrint("data \(String(data: data, encoding: String.Encoding.utf8) as String?)")
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password)
        taskForRequest(skipSecurity: false, method: "POST", url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                getPublicUserInfo() { userInfo, error in
                    if let userInfo = userInfo {
                        Auth.studentInfo = userInfo
                      completion(true, nil)
                    } else {
                        completion(false, error)
                    }
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func deleteSession(completion: @escaping (LogoutResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        taskForRequestWithoutBody(method: "DELETE", url: Endpoints.logout.url, responseType: LogoutResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
            Auth.sessionId = ""
        }
    }
    
    
    class func get100LastStudentLocations(completion: @escaping ([StudentInformation]?, Error?) -> Void) -> URLSessionDataTask {
        return taskForRequestWithoutBody(method: "GET", url: Endpoints.studentLocations(limit: 100, order: "-updatedAt").url, responseType: StudentsResponse.self) { response, error in
            if let response = response {
                let studentInfo = cleanStudentInfo(response.results)
                completion(studentInfo, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func cleanStudentInfo(_ studentInfos: [StudentInformation]) -> [StudentInformation] {
        var result: [StudentInformation] = []
        for studentInfo in studentInfos {
            
            if !verifyUrl(urlString: studentInfo.mediaURL) || studentInfo.firstName == nil || studentInfo.lastName == nil || studentInfo.lastName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true || studentInfo.firstName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                debugPrint("skipping...")
                continue
            } else {
                result.append(studentInfo)
            }
        }
        return result
    }
    
    // https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift/36012850
    class func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }

        return UIApplication.shared.canOpenURL(url)
    }
    
    class func postStudentLocation(info: StudentInformation, completion: @escaping (LocationCreatedResponse?, Error?) -> Void) {
        taskForRequest(skipSecurity: true, method: "POST", url: Endpoints.studentLocation.url, responseType: LocationCreatedResponse.self, body: info) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func putStudentLocation(info: StudentInformation, completion: @escaping (LocationUpdatedResponse?, Error?) -> Void) {
        if let objectId = info.objectId {
            taskForRequest(skipSecurity: true, method: "PUT", url: Endpoints.studentPutLocation(objectId: objectId).url, responseType: LocationUpdatedResponse.self, body: info) { response, error in
                if let response = response {
                    completion(response, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func getPublicUserInfo(completion: @escaping (PublicUserInfo?, Error?) -> Void) {
        taskForRequestWithoutBody(skipSecurity: false, method: "GET", url: Endpoints.userInfo(userId: Auth.accountId).url, responseType: PublicUserInfo.self) { userInfo, error in
            if let response = userInfo {
                completion(response, nil)
            } else {
                debugPrint("public user info error: ", error?.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
    class func skipUdacitySecurity(_ data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
}
