//
//  Specification+CoreDataProperties.swift
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

extension Specification {

    @NSManaged var avgFuel: NSNumber?
    @NSManaged var conditionRating: NSNumber?
    @NSManaged var horsepower: NSNumber?
    @NSManaged var safetyRating: NSNumber?
    @NSManaged var type: String?
    @NSManaged var cars: Car?

}
