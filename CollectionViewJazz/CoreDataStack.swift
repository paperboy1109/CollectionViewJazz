//
//  CoreDataStack.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    // TODO: Create entities in the xcdatamodel
    let model = "Model"
    
    // STEP 1 of 4: set the application documents directory
    
    // *****
    // ***** DocumentDirectory is the recommended place to store users' data *****
    // *****
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count-1]
    }()
    
    
    
    
    // STEP 2 of 4: set the managed object model
    // "A managed object model describes the entities in the stores."
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.model, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    
    // STEP 3 of 4: set the persistence store coordinator
    // "A stack is effectively defined by a persistent store coordinator—there is one and only one per stack. "
    
    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.model)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        catch {
            fatalError("Error adding persistence store")
        }
        
        return coordinator
    }()
    
    
    // STEP 4 of 4: Set the managed object context
    // "A managed object context is usually connected directly to a persistent store coordinator, but may be connected to another context in a parent-child relationship."
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        return context
    }()
    
    // MARK: - Helpers
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch {
                print("Error saving context")
                abort()
            }
        }
    }
}
