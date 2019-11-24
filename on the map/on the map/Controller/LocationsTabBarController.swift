//
//  LocationsTabBarController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

class LocationsTabBarController: UITabBarController {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = DataController.isLoading ? "Loading..." : "On the Map"
        DataController.setRefreshHandler() { isLoading in
            self.navigationItem.title = isLoading ? "Loading..." : "On the Map"
            self.refreshButton.isEnabled = !isLoading
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataController.clearRefreshHandler()
    }
    
    @IBAction func onLogoutClick(_ sender: Any) {
        UdacityClient.deleteSession() { deleted, error in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        DataController.reloadStudentLocationsData()
        debugPrint("refresh pressed")
    }
}
