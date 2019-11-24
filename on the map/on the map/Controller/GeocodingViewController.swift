//
//  GeocodingViewController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit
import MapKit

class GeocodingViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var postInfo: StudentInformation!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.setTitle("Please wait...", for: .disabled)
        addUserLocToMapAndZoom(studentInfo: postInfo)
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        submitButton.isEnabled = false
        UdacityClient.postStudentLocation(info: postInfo) { response, error in
            if let _ = response {
               self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                let errorAlertController = UIAlertController(title: "Submitting failed", message: error.localizedDescription, preferredStyle: .alert)
                errorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
                self.navigationController?.present(errorAlertController, animated: true, completion: nil)
            }
            self.submitButton.isEnabled = true
        }
    }
    
    func addUserLocToMapAndZoom(studentInfo: StudentInformation) {
        if let latVal = studentInfo.latitude, let longVal = studentInfo.longitude {
            let lat = CLLocationDegrees(latVal)
            let long = CLLocationDegrees(longVal)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentInfo.firstName ?? ""
            let last = studentInfo.lastName ?? ""
            let mediaURL = studentInfo.mediaURL ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            mapView.addAnnotation(annotation)
            zoomToAnnotation(annotation: annotation)
        }
    }
    
    func zoomToAnnotation(annotation: MKPointAnnotation) {
        var zoomRect = MKMapRect.null
        let annotationPoint = MKMapPoint(annotation.coordinate)
        let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 100, height: 100)
        if (zoomRect.isNull) {
            zoomRect = pointRect
        } else {
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), animated: true)
    }
}
