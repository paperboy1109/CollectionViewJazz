//
//  DataService.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import CoreData

public class DataService {
    
    public var managedObjectContext: NSManagedObjectContext!
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    
    func getInventory() -> [Car] {
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.fetchBatchSize = 16
        let results: [Car]
        
        do {
            results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Car]
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }    
    
    
}
