//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 27/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var imageData: NSData?
    @NSManaged var imageUrl: String?
    @NSManaged var pin: Pin?

}
