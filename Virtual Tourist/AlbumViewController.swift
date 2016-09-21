//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 21/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import MapKit
import UIKit

class AlbumViewController: UIViewController {

    var annotation: MKPointAnnotation!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionButton: UIBarButtonItem!

}
