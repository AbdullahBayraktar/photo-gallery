//
//  PhotoGalleryDummyBrokenDataController.swift
//  PhotoGalleryTests
//
//  Created by Abdullah Bayraktar on 10.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation
@testable import PhotoGallery

final class PhotoGalleryDummyBrokenDataController: PhotoGalleryDataProtocol {
    
    func retrieveImagesData(completion: @escaping PhotoGalleryRequestCompletion) {
        
        FileHandler.retrieveImagesData { (imagesData, _) in
            let error = NSError(domain: "",
                                code: -1,
                                userInfo: [ NSLocalizedDescriptionKey: "The data couldn’t be read because it isn’t in the correct format."])
            completion(nil, error)
        }
    }
}
