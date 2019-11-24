//
//  MapViewController.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/22/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var updateHandlerId: Int?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHandlerId = DataController.addUpdateHandler(handler: onDataReload(infos:error:))
        if !DataController.isLoading && DataController.studentsInformation.count == 0 {
            DataController.reloadStudentLocationsData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let id = updateHandlerId {
            DataController.removeUpdateHandler(id: id)
        }
    }
    
    func onDataReload(infos: [StudentInformation]?, error: Error?) {
        if let error = error {
            let errorAlertController = UIAlertController(title: "Updating map failed", message: error.localizedDescription, preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(errorAlertController, animated: true, completion: nil)
        } else if let _ = infos {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(DataController.annotations)
        }
    }
    
    // udacity pin sample app in lesson
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("clicked")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
