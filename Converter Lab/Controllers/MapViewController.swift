//
//  MapViewController.swift
//  Converter Lab
//
//  Created by Albert on 02.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var geocoder: CLGeocoder!
    var address = ""
    
    @IBOutlet weak var myMapKit: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placeMarks, error) in
            if error != nil {
                print("Error \(error.debugDescription)")
            }
            if placeMarks != nil {
                if let placeMark = placeMarks?.first {
                    let annotation = MKPointAnnotation()
                    annotation.title = self?.address
                    annotation.coordinate = placeMark.location!.coordinate
                    
                    self?.myMapKit.showAnnotations([annotation], animated: true)
                    self?.myMapKit.selectAnnotation(annotation, animated: true)
                    
                }
            }
        }
    }
}
