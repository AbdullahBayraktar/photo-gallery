//
//  PhotoGalleryViewController+UICollectionViewDelegate.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 6.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegate

extension PhotoGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let imageData = viewModel.imageData(at: indexPath.row),
            let image = UIImage(data: imageData) else {
            return
        }
        
        router.route(to: Route.imageSelection.rawValue,
                     from: self,
                     parameters: image)
    }
}
