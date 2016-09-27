//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 24/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Photo: NSManagedObject {

    init(pin: Pin, imageUrl: String, imageData: NSData, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.pin = pin
        self.imageUrl = imageUrl
        self.imageData = imageData
    }

}
