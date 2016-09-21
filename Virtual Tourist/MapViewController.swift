//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 21/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var isInEditMode = false

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageView: UIView!

    @IBOutlet weak var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPinOnMap(_:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        messageView.center.y += 100
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DisplayAlbum" {
            let albumViewController = segue.destinationViewController as! AlbumViewController
            let annotation = sender as! MKPointAnnotation
            albumViewController.annotation = annotation
        }
    }

    func addPinOnMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != .Began {
            let point = gestureRecognizer.locationInView(mapView)
            let coordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation!

        if isInEditMode {
            mapView.removeAnnotation(annotation)
        } else {
            performSegueWithIdentifier("DisplayAlbum", sender: annotation)
        }
    }

    @IBAction func editMode(sender: AnyObject) {
        isInEditMode = !isInEditMode

        if isInEditMode {
            editButton.title = "Done"
            messageView.center.y -= 100
            mapView.frame.origin.y -= 100
        } else {
            editButton.title = "Edit"
            messageView.center.y += 100
            mapView.frame.origin.y += 100
        }
    }

}

