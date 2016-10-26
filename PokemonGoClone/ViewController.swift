//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by ROHIT GUPTA on 10/25/16.
//  Copyright © 2016 ROHIT GUPTA. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("We are ready to go!")
            mapView.showsUserLocation = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

