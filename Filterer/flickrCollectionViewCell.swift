//
//  flickrCollectionViewCell.swift
//  Filterer
//
//  Created by Yi Zhou on 3/31/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

class flickrCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }
    
}
