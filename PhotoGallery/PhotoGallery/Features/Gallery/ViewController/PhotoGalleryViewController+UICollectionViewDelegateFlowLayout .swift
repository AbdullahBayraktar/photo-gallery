//
//  PhotoGalleryViewController+UICollectionViewDelegateFlowLayout .swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 6.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

private enum Constant {
    static let sectionInsets = UIEdgeInsets(top: 10.0,
                                            left: 10.0,
                                            bottom: 10.0,
                                            right: 10.0)
    static let numberOfItemsInARow = 3.0
    static let paddingSpace = Constant.sectionInsets.left * CGFloat(Constant.numberOfItemsInARow + 1)
}

// MARK: - UICollectionViewFlowLayout

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = view.frame.width - Constant.paddingSpace
        let widthPerItem = availableWidth /  CGFloat(Constant.numberOfItemsInARow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return Constant.sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return Constant.sectionInsets.left
    }
}
