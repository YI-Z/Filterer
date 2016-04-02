//
//  flickrCollectionViewCell.swift
//  Filterer
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
