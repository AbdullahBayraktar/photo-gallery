//
//  PhotoGalleryDataController.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

final class PhotoGalleryDataController: PhotoGalleryDataProtocol {
    
    func retrieveImagesData(completion: @escaping PhotoGalleryRequestCompletion) {
        
        let imagesData = FileHandler.retrieveImagesData()
        completion(imagesData, nil)
    }
}
