//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Aayush Kapoor on 29/09/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        if imageView.image == nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.hidden = false
                self.activityIndicator.startAnimating()
            })
        }
    }
    
}