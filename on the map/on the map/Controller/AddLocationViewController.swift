//
//  AddLocationViewController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var findLocButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var url: UITextField!

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(error: String) {
        errorLabel.text = error
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("Prepare for segue")
    }
    
    @IBAction func onFindLocationClicked(_ sender: Any) {
        hideError()
        if !UdacityClient.verifyUrl(urlString: url.text) || locationField.text!.isEmpty {
            showError(error: "Please enter valid data. URL must contain scheme. Example: http://google.com")
            debugPrint("enter valid data")
            return
        }
        findLocButton.isEnabled = false
        indicator.startAnimating()
        CLGeocoder().geocodeAddressString(locationField.text!, completionHandler: {placemarks, error in
            self.indicator.stopAnimating()
            self.findLocButton.isEnabled = true
            if let placemarks = placemarks {
                let latitude = placemarks[0].location?.coordinate.latitude
                let longitude = placemarks[0].location?.coordinate.longitude
                let studentInformation = StudentInformation(objectId: nil, uniqueKey: "1234", firstName: UdacityClient.Auth.studentInfo?.firstName, lastName: UdacityClient.Auth.studentInfo?.lastName, mapString: self.locationField.text, mediaURL: self.url.text, latitude: latitude, longitude: longitude, createdAt: nil, updatedAt: nil)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let geocodeVC = storyBoard.instantiateViewController(withIdentifier: "geocodingViewController") as! GeocodingViewController
                geocodeVC.postInfo = studentInformation
                self.navigationController?.pushViewController(geocodeVC, animated: true)
                return
            }
            if let error = error as? CLError {
                switch error.code {
                case .network :
                    self.showError(error: "Check network connection")
                case .geocodeFoundNoResult:
                    self.showError(error: "No location found")
                default:
                    self.showError(error: "Unable to obtain location")
                }
            }
        })
    }
}
