//
//  PhotoGalleryDataProtocol.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

typealias PhotoGalleryRequestCompletion = ([Data]?, Error?) -> Void

protocol PhotoGalleryDataProtocol {

    /// Retrieves photos
    ///
    /// - Parameters:
    ///   - completion: Completion block
    func retrieveImagesData(completion: @escaping PhotoGalleryRequestCompletion)
}
