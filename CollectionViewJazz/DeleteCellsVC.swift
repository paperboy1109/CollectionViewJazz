//
//  DeleteCellsVC.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/26/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import CoreData

class DeleteCellsVC: UIViewController {
    
    // MARK: - Properties
    
    // var managedObjectContext: NSManagedObjectContext!
    // var coreDataStack: CoreDataStack!
    var sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    
    // var fetchedResultsController: NSFetchedResultsController!
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    var carToDelete: Car?
    
    var dataService: DataService!
    
    var carArray: [Car] = []
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.managedObjectContext = coreDataStack.managedObjectContext
        
        /* Configure the collection view */
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // Start the fetched results controller
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("Error performing initial fetch: \(error)")
        }
        
        
        
        /* Load sample data without a Fetched Results Controller */
        // dataService = DataService(managedObjectContext: managedObjectContext)
        // carArray = dataService.getInventory()
        
        // Use the Fetched Results Controller
        loadDataWithFetchedResultsController()
    }
    
    // MARK: - NSFetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Helpers
    
    func loadDataWithFetchedResultsController() {
        /*
        print("loadDataWithFetchedResultsController called")
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetched results controller failed to perform the fetch")
        }
        */
    }


}

// MARK: - Delegate methods for the collection view


extension DeleteCellsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //return 1
        
        // Use the Fetched Results Controller
        print("in numberOfSectionsInCollectionView()")
        return self.fetchedResultsController.sections!.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return carArray.count
        
        // Use the Fetched Results Controller
        print("in collectionView(_:numberOfItemsInSection)")
        let sectionInfo = fetchedResultsController.sections![section]
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print("in collectionView(_:cellForItemAtIndexPath)")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! DeleteCellsCollectionViewCell
        
        cell.imageView.backgroundColor = UIColor.blueColor()
        
        
        /* Without the Fetched Results Controller */
        /*
        let car = carArray[indexPath.row]
        let carImage = car.carImage!
        let carUIImage = UIImage(data: carImage.image!)
        cell.imageView.image = carUIImage */
        
        /* With the Fetched Results Controller */
        let carFromfetchedResultsController = fetchedResultsController.objectAtIndexPath(indexPath) as! Car        
        let image = carFromfetchedResultsController.carImage!
        let imageUIImage = UIImage(data: image.image!)
        cell.imageView.image = imageUIImage
        
        return cell
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("in collectionView(_:didSelectItemAtIndexPath)")
        
        print("Cell at index path \(indexPath) was tapped ")
        
        carToDelete = fetchedResultsController.objectAtIndexPath(indexPath) as? Car
        
        /*
        self.managedObjectContext.deleteObject(self.carToDelete!)
        self.coreDataStack.saveContext()
        self.carToDelete = nil
         */
        
        self.sharedContext.deleteObject(carToDelete!)
                
    }
    
    
    
    
}

// MARK: - Delegate methods for the fetched results controller

extension DeleteCellsVC: NSFetchedResultsControllerDelegate {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        /* Detect the type of change that has triggered the event */
        
        switch type {
            
        case .Insert:
            print("NSFetchedResultsChangeType.Insert detected")
            let newIndexPathAdjusted = NSIndexPath(forItem: newIndexPath!.item, inSection: 0)
            insertedIndexPaths.append(newIndexPathAdjusted)
        case .Delete:
            print("NSFetchedResultsChangeType.Delete detected")
            let indexPathAdjusted = NSIndexPath(forItem: indexPath!.item, inSection: 0)
            deletedIndexPaths.append(indexPathAdjusted)
        case .Update:
            print("NSFetchedResultsChangeType.Update detected")
            let indexPathAdjusted = NSIndexPath(forItem: indexPath!.item, inSection: 0)
            updatedIndexPaths.append(indexPathAdjusted)
        case .Move:
            print("NSFetchedResultsChangeType.Move detected")
            fallthrough
        default:
            break
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        self.collectionView.performBatchUpdates( { () -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            }, completion: { (success) in
                
                print("The completion handler for controllerDidChangeContent was called")
                print("Here is 'success':  ")
                print(success)
                
                /*
                if !self.getPhotoDownloadStatus().completed {
                    self.downloadAnImage()
                } */
            }
        )

    }
    
    
}

extension DeleteCellsVC {
    // Delete this extension.  It exists only to verify that the sharedInstance branch has changes that 'master' does not.
}