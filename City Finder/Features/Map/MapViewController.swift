//
//  MapViewController.swift
//  City Finder
//
//  Created by Attia Mo on 9/24/18.
//  Copyright © 2018 Attia Mo. All rights reserved.
//

import UIKit

import  MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var city:City?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapViewStyle()
        self.title = city?.name ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dropPins() {
        //Remove pins and add the new ones 
        mapView.removeAnnotations(mapView.annotations)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.title = city?.name ?? ""
        annotation.subtitle = city?.country ?? ""
        annotation.coordinate = CLLocationCoordinate2D(latitude: (city?.coord?.lat)!, longitude:  (city?.coord?.lon)!)
        self.mapView.showAnnotations([annotation], animated: true)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        self.mapView.setRegion(region, animated: false)
    }
    
    // MARK: private methods
    
    private func setUpMapViewStyle(){
        self.mapView.delegate = self
        self.mapView.showsCompass = true
        self.mapView.showsBuildings = true
        dropPins()
    }

    // MARK: MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "cityPin"
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        var annotationView:MKPinAnnotationView? =
            mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        annotationView?.pinTintColor = UIColor.blue
        return annotationView
    }
}
