//
//  API.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 24/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import CoreData
import Foundation

struct API {

    static let apiKey = ""

    static func getPhotoUrlsForPin(pin: Pin, handler: (result: [String]) -> Void) {

        let latitude = pin.latitude
        let longitude = pin.longitude

        let sortOptions = ["date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc", "interestingness-desc", "interestingness-asc", "relevance"]

        let sortOption = sortOptions[Int(arc4random_uniform(UInt32(sortOptions.count)))]

        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)" +
        "&sort=\(sortOption)" +
        "&lat=\(latitude)&lon=\(longitude)" +
        "&per_page=21&format=json&nojsoncallback=1"
        .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()

        let photosTask = session.dataTaskWithRequest(request, completionHandler: {

            guard $0.2 == nil else {
                fatalError($0.2!.domain)
            }

            do {
                let data = try NSJSONSerialization.JSONObjectWithData($0.0!, options: .AllowFragments)

                guard let result = data["photos"] as? [String: AnyObject] else {
                    fatalError("Could not parse result")
                }

                guard let photos = result["photo"] as? [[String: AnyObject]] else {
                    fatalError("Could not parse photos")
                }

                let photoUrls: [String] = photos.map {
                    let id = $0["id"]!
                    let farm = $0["farm"]!
                    let server = $0["server"]!
                    let secret = $0["secret"]!

                    return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
                }

                handler(result: photoUrls)

            } catch {
                print("JSON parse error...")
            }

        })

        photosTask.resume()
    }

    static func getImageForPhoto(photo: Photo, handler: () -> Void) {

        let url = NSURL(string: photo.imageUrl!)
        let session = NSURLSession.sharedSession()
        let photoTask = session.dataTaskWithURL(url!, completionHandler: {

            if $0.2 == nil {
                let imageData = $0.0
                dispatch_async(dispatch_get_main_queue(), {
                    photo.imageData = imageData
                    CoreDataStackManager.sharedInstance().saveContext()
                    handler()
                })
            } else {
                print("Error getting image data")
            }

        })

        photoTask.resume()
    }
}
