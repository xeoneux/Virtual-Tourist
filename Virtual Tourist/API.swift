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

        session.dataTaskWithRequest(request, completionHandler: {

            guard $0.2 == nil else {
                handler(result: nil, error: $0.2)
                return
            }

            do {
                let data = try NSJSONSerialization.JSONObjectWithData($0.0!, options: .AllowFragments)
                handler(result: data, error: nil)
            } catch {
                print("JSON parse error...")
            }

        })
    }
}
