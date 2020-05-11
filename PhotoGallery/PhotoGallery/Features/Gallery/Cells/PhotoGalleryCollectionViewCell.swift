//
//  PhotoGalleryCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class PhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var imageView: UIImageView!
    
    // MARK: - Views
    
    func configureCell(image: UIImage? = nil) {
        imageView.image = image
    }
}
