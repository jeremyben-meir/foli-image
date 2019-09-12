//
//  MapViewController.swift
//  foli-image
//
//  Created by Jeremy Ben-Meir on 8/1/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate{
    
    //@IBOutlet weak var mapView: MKMapView!
    var location: CLLocation?
    var tree: Tree
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let didFindMyLocation = false

    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    var switchItem: UISwitch!
    
    init(inputTree: Tree){
        tree = inputTree
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        var camera = GMSCameraPosition.camera(withLatitude: 42.4534,longitude: -76.4735, zoom: zoomLevel)
        
        if let validLocation = location {
            camera = GMSCameraPosition.camera(withLatitude: validLocation.coordinate.latitude, longitude: validLocation.coordinate.longitude, zoom: zoomLevel)
            let position = CLLocationCoordinate2D(latitude: validLocation.coordinate.latitude, longitude: validLocation.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.title = "Image Location"
            marker.map = mapView
        }
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        // GOOGLE MAPS SDK: BORDER
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
        
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        //print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        tree.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}



