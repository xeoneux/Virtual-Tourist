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

    static func getPhotoUrlsForPin(pin: Pin, handler: (result: AnyObject?, error: NSError?) -> Void) {

        let latitude = pin.latitude
        let longitude = pin.longitude

        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)" +
        "&lat=\(latitude)&lon=\(longitude)" +
        "&per_page=21&format=json&nojsoncallback=1"
        .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()

        let photosTask = session.dataTaskWithRequest(request, completionHandler: {

            guard $0.2 == nil else {
                handler(result: nil, error: $0.2)
                return
            }

            do {
                let data = try NSJSONSerialization.JSONObjectWithData($0.0!, options: .AllowFragments)

                guard let result = data["photos"] as? [String: AnyObject] else {
                    fatalError("Could not parse result")
                }

                guard let photos = result["photo"] as? [[String: AnyObject]] else {
                    fatalError("Could not parse photos")
                }

                for photo in photos {

                    let id = photo["id"]!
                    let farm = photo["farm"]!
                    let server = photo["server"]!
                    let secret = photo["secret"]!
                    let imageUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"

                    let context = CoreDataStackManager.sharedInstance().managedObjectContext

                    Photo(pin: pin, imageUrl: imageUrl, context: context)
                }

                pin.hasPhotos = true
                CoreDataStackManager.sharedInstance().saveContext()

            } catch {
                print("JSON parse error...")
            }

        })

        photosTask.resume()
    }

    static func getPhotoForUrl(pin: Pin, imageUrl: NSURL, handler: (result: AnyObject?, error: NSError?) -> Void) {

        let session = NSURLSession.sharedSession()
        let photoTask = session.dataTaskWithURL(imageUrl, completionHandler: {

            if $0.2 == nil {
                handler(result: $0.0, error: nil)
            } else {
                print("Error getting image data")
            }

        })

        photoTask.resume()
    }
}
