//
//  Car+CoreDataProperties.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Car {

    @NSManaged var make: String?
    @NSManaged var model: String?
    @NSManaged var price: NSNumber?
    @NSManaged var thumbnail: NSData?
    @NSManaged var year: NSNumber?
    @NSManaged var carImage: CarImage?
    @NSManaged var specs: Specification?

}
