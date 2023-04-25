//
//  LocationSearchVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 3/5/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchVC: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var callback : ((String)->())?
    var selected: String? = nil
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchBar?.delegate = self

        searchBar.placeholder = "Search for places"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.view.addGestureRecognizer(tap)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        callback?(selected ?? "")
    }
    @objc func dismissKeyboard() {
        //Hides keyboard
        view.endEditing(true)
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        getCurrentLocation()
    }
    private func getCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}
//MARK: - TableView delegate..
extension LocationSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchTableCell") as! LocationSearchTableCell
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            guard let name = response?.mapItems[0].name else { return }
            guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }
            
            self.selected = name
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        // Reload the tableview with our new searchResults
        tableView.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        // Error
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
// MARK: - LocationDelegate
extension LocationSearchVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let currentlocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        fetchCityAndCountry(from: currentlocation) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.selected = "\(city) , \(country)"
            self.locationManager.stopUpdatingLocation()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
}
