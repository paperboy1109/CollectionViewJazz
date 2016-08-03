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
    
    var managedObjectContext: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController!
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
        
        /* Configure the collection view */
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /* Load sample data without a Fetched Results Controller */
        // dataService = DataService(managedObjectContext: managedObjectContext)
        // carArray = dataService.getInventory()
        
        // Use the Fetched Results Controller
        loadDataWithFetchedResultsController()
    }
    
    // MARK: - Helpers
    
    func loadDataWithFetchedResultsController() {
        
        print("loadDataWithFetchedResultsController called")
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetched results controller failed to perform the fetch")
        }
        
    }


}


extension DeleteCellsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //return 1
        
        // Use the Fetched Results Controller
        return fetchedResultsController.sections!.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return carArray.count
        
        // Use the Fetched Results Controller
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! DeleteCellsCollectionViewCell
        
        cell.imageView.backgroundColor = UIColor.blueColor()
        
        
        /* Without the Fetched Results Controller */
        /*
        let car = carArray[indexPath.row]
        let carImage = car.carImage!
        let carUIImage = UIImage(data: carImage.image!)
        cell.imageView.image = carUIImage */
        
        /* With the Fetched Results Controller */
        //x let indexPathAdjusted = NSIndexPath(forItem: indexPath.item - numberOfStaticCells, inSection: 0)
        //x use adjusted indexPath for fetching an object
        //x let photo = fetchedResultsController.objectAtIndexPath(indexPathAdjusted) as! Photo
        let carFromfetchedResultsController = fetchedResultsController.objectAtIndexPath(indexPath) as! Car
        //x var imageData: NSData!
        let image = carFromfetchedResultsController.carImage!
        let imageUIImage = UIImage(data: image.image!)
        cell.imageView.image = imageUIImage
        
        return cell
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Cell at index path \(indexPath) was tapped ")
        
        /*
        carToDelete = fetchedResultsController.objectAtIndexPath(indexPath) as? Car
        self.managedObjectContext.deleteObject(self.movieToDelete!)
        self.coreData.saveContext()
        self.movieToDelete = nil */
        
    }
    
    
    
    
}


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
            }, completion: nil /*{ (success) in
                if !self.getPhotoDownloadStatus().completed {
                    self.downloadAnImage()
                }
            } */
        )

    }
    
    
}