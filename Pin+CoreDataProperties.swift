//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 03/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var hasPhotos: Bool
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var photo: NSSet?

}
