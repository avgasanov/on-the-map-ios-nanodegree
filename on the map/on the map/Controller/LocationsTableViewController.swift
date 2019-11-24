//
//  LocationsTableViewController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/23/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class LocationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var handlerId: Int?
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        handlerId = DataController.addUpdateHandler(handler: onDataReload(result:error:))
        if !DataController.isLoading && DataController.studentsInformation.count == 0 {
            DataController.reloadStudentLocationsData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let handlerId = handlerId {
            DataController.removeUpdateHandler(id: handlerId)
        }
    }
    
    func onDataReload(result: [StudentInformation]?, error: Error?) {
        if let error = error {
            let errorAlertController = UIAlertController(title: "Loading data failed", message: error.localizedDescription, preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(errorAlertController, animated: true, completion: nil)
            debugPrint(error.localizedDescription)
        } else if let result = result {
            debugPrint("data count: \(result.count)")
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataController.studentsInformation.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
        let studentLocation = DataController.studentsInformation[indexPath.row]
        cell?.textLabel?.text = "\(studentLocation.lastName ?? "") \(studentLocation.firstName ?? "")"
        cell?.detailTextLabel?.text = studentLocation.mediaURL ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = DataController.studentsInformation[indexPath.row].mediaURL
        debugPrint(indexPath.row)
        if UdacityClient.verifyUrl(urlString: url) {
            UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
