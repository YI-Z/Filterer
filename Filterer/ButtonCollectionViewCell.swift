//
//  ButtonCollectionViewCell.swift
//  Filterer
//
//  Created by Yi Zhou on 3/17/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var textLabel : UILabel!
    var imageView : UIImageView!
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: (frame.width - 32) / 2.0, y: 2, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFill
        contentView.addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: 0, y: 34, width: frame.width, height: frame.height - 34))
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }

}
