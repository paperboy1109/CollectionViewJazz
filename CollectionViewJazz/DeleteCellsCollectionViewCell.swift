//
//  DeleteCellsCollectionViewCell.swift
//  CollectionViewJazz
//
//  Created by Daniel J Janiak on 7/26/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class DeleteCellsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        // Configure the cell
        layer.borderWidth = 0.8
        layer.cornerRadius = 5
        layer.borderColor = UIColor.grayColor().CGColor
    }
    
}
