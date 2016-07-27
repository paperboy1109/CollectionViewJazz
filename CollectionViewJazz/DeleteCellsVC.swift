//
//  DeleteCellsVC.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/26/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class DeleteCellsVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* Configure the collection view */
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DeleteCellsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! DeleteCellsCollectionViewCell
        
        cell.imageView.backgroundColor = UIColor.blueColor()
        
        return cell
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Cell at index path \(indexPath) was tapped ")
        
    }
    
    
    
    
}