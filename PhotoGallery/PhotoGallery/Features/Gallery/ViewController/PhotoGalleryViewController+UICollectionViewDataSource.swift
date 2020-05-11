//
//  PhotoGalleryViewController+UICollectionViewDataSource.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 6.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension PhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoGalleryCollectionViewCell.className,
            for: indexPath) as! PhotoGalleryCollectionViewCell
        
        guard let image = viewModel.thumbnailImage(at: indexPath.row) else {
            cell.configureCell()
            return cell
        }

        cell.configureCell(image: image)
        return cell
    }
}
