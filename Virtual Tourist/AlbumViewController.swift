//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 21/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    var pin: Pin!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIBarButtonItem!

    override func viewDidLoad() {
        let center = pin.coordinate
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)

        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        mapView.addAnnotation(annotation)

        try! fetchedResultsController.performFetch()
        collectionView.backgroundColor = UIColor.whiteColor()
    }

    @IBAction func collectionButtonTapped(sender: AnyObject) {
        let photos = fetchedResultsController.fetchedObjects as! [Photo]
        let indexPaths = collectionView.indexPathsForVisibleItems()

        indexPaths.forEach {
            let cell = collectionView.cellForItemAtIndexPath($0) as! PhotoCollectionViewCell
            cell.imageView.image = UIImage(named: "placeholder")
        }

        photos.forEach {
            $0.imageData = nil
        }

        API.getPhotoUrlsForPin(pin, handler: {
            let imageUrls = $0

            dispatch_async(dispatch_get_main_queue(), {
                for (index, imageUrl) in imageUrls.enumerate() {
                    photos[index].imageUrl = imageUrl
                }

                self.collectionView.reloadData()
            })
        })
    }

    // MARK: Core Data

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.sortDescriptors = []

        let context = CoreDataStackManager.sharedInstance().managedObjectContext

        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()

    // MARK: Collection View

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell

        cell.activityIndicator.hidden = false
        cell.activityIndicator.startAnimating()
        cell.imageView.image = UIImage(named: "placeholder")

        API.getPhotoUrlsForPin(pin, handler: {
            let imageUrls = $0
            let imageUrl = imageUrls[Int(arc4random_uniform(UInt32(imageUrls.count)))]

            dispatch_async(dispatch_get_main_queue(), {
                photo.imageUrl = imageUrl
                CoreDataStackManager.sharedInstance().saveContext()
            })

            API.getImageForPhoto(photo, handler: {
                dispatch_async(dispatch_get_main_queue(), {
                    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
                    cell.activityIndicator.hidden = true
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                })
            })
        })
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo

        if photo.imageData != nil {
            cell.activityIndicator.hidden = true
            cell.imageView.image = UIImage(data: photo.imageData!)
        } else {
            cell.activityIndicator.hidden = false
            cell.activityIndicator.startAnimating()
            cell.imageView.image = UIImage(named: "placeholder")
            API.getImageForPhoto(photo, handler: {
                cell.activityIndicator.hidden = true
                collectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 3, height: collectionView.bounds.size.width / 3)
    }

}
