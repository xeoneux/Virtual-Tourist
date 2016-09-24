//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 24/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var filePath: String?
    @NSManaged var id: String?
    @NSManaged var imageUrl: String?
    @NSManaged var pin: Pin?

}
