//
//  API.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 24/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation

struct API {

    static let apiKey = ""

    static func getPhotoUrlsForLocation(latitude: Double, longitude: Double, handler: (result: AnyObject?, error: NSError?) -> Void) {

        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)" +
        "&lat=\(latitude)&lon=\(longitude)" +
        "&per_page=21&format=json&nojsoncallback=1"
        .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request, completionHandler: {

            guard $0.2 == nil else {
                handler(result: nil, error: $0.2)
                return
            }

            var photoUrls = [NSURL]()

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

                    let string = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
                    let url = NSURL(string: string)!
                    photoUrls.append(url)
                }

                handler(result: photoUrls, error: nil)
            } catch {
                print("JSON parse error...")
            }

        })

        task.resume()
    }
}