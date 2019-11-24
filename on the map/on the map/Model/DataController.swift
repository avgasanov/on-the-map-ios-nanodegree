//
//  DataController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import Foundation
import MapKit

class DataController {
    static var idCounter = 0
    static var updateHandlers = Dictionary<Int, (_ result: [StudentInformation]?, _ error: Error?) -> Void>()
    private static var getTask: URLSessionDataTask?
    static var isLoading: Bool = false
    static var refreshHandler: ((Bool) ->Void)?
    
    // Data Model
    static var studentsInformation = [StudentInformation]()
    static var annotations = [MKPointAnnotation]()
    
    class func setRefreshHandler(handler: @escaping (Bool) -> Void) {
        refreshHandler = handler
    }
    
    class func clearRefreshHandler() {
        refreshHandler = nil
    }
    
    class func addUpdateHandler(handler: @escaping (_ result: [StudentInformation]?, _ error: Error?) -> Void) -> Int {
        idCounter += 1
        updateHandlers[idCounter] = handler
        return idCounter
    }
    
    class func removeUpdateHandler(id: Int) {
        updateHandlers[id] = nil
    }
    
    class func reloadStudentLocationsData() {
        refreshHandler?(true)
        isLoading = true
        if let task = getTask {
            task.cancel()
        }
        getTask = UdacityClient.get100LastStudentLocations() { studentsInfo, error in
            refreshHandler?(false)
            isLoading = false
            if let studentsInfo = studentsInfo {
                self.studentsInformation = studentsInfo
                createAnnotations()
            }
            for updateHandler in updateHandlers {
                updateHandler.value(studentsInfo, error)
            }
    }
        
    }
    
    // Udacity pin sample app from lesson
    class func createAnnotations() {
        for info in studentsInformation {
            if let latVal = info.latitude, let longVal = info.longitude {
                let lat = CLLocationDegrees(latVal)
                let long = CLLocationDegrees(longVal)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = info.firstName ?? ""
                let last = info.lastName ?? ""
                let mediaURL = info.mediaURL ?? ""
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
        }
    }
    
}
