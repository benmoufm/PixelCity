//
//  MapDelegate.swift
//  PixelCity
//
//  Created by Mélodie Benmouffek on 22/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

extension MapViewController: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }

    func retrieveUrls(forAnnotation annotation: DroppablePin, completionHandler: @escaping (_ status: Bool) -> Void) {
        imageUrlsArray = []
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, addNumberOfPhotos: 40))
            .responseJSON { (response) in
                if response.result.error == nil {
                    guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                    let photosDictionnary = json["photos"] as! Dictionary<String, AnyObject>
                    let photosDictionnayArray = photosDictionnary["photo"] as! [Dictionary<String, AnyObject>]
                    for photo in photosDictionnayArray {
                        let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                        self.imageUrlsArray.append(postUrl)
                    }
                    completionHandler(true)
                } else {
                    debugPrint(response.result.error as Any)
                    completionHandler(false)
                }
        }
    }

    //MARK: - Delegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }

    //MARK: - @objc functions
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin()
        removeSpinner()
        removeProgressLabel()
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        animateViewUp()
        addSpinner()
        addProgressLabel()
        retrieveUrls(forAnnotation: annotation) { (success) in
            if success {

            }
        }
    }
}
