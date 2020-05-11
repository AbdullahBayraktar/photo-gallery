//
//  PhotoGalleryDummyDataController.swift
//  PhotoGalleryTests
//
//  Created by Abdullah Bayraktar on 9.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation
import UIKit
@testable import PhotoGallery

final class PhotoGalleryDummyDataController: PhotoGalleryDataProtocol {
    
    func retrieveImagesData(completion: @escaping PhotoGalleryRequestCompletion) {
        
        FileHandler.retrieveImagesData { (imagesData, error) in
            completion(imagesData, error)
        }
    }
}
