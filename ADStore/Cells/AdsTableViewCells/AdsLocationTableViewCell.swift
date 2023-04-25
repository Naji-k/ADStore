//
//  AdsLocationTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 9/21/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import MapKit

class AdsLocationTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.showsPointsOfInterest = true
        if let mapView = self.mapView {
            mapView.delegate = self
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showLocation(location:CLLocation) {
        let orgLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        mapView!.addAnnotation(dropPin)
        self.mapView?.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
    }
    func showLocation2 (location: CLLocation) {
        let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)

    }
    func loc(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let resault = placemarks.first?.location
            else {
                // handle no location found
                return
            }

            // Use your location
            let location = CLLocationCoordinate2D(latitude: resault.coordinate.latitude, longitude: resault.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: false)
            
        }
    }
    
}
