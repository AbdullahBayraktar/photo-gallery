//
//  PhotoGalleryViewModel.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

private enum ImageSize {
    static let thumbnail = CGSize(width: 200, height: 200)
}

final class PhotoGalleryState {

    /// Possible changes
    enum Change {
        case images(Bool)
        case newImage(Bool)
        case empty(message: String)
        case error(Error?)
    }

    /// Triggered when change occured
    var onChange: ((PhotoGalleryState.Change) -> Void)?

    /// Images state
    fileprivate(set) var areImagesAvailable: Bool = false {
        didSet { onChange?(.images(areImagesAvailable)) }
    }
    
    /// New image state
    fileprivate(set) var isNewImageAdded: Bool = false {
        didSet { onChange?(.newImage(isNewImageAdded)) }
    }
    
    /// Availablity message state
    fileprivate(set) var availabilityMessage: String? {
        didSet {
            if let message = availabilityMessage {
                onChange?(.empty(message: message))
            }
        }
    }
    
    /// Error state
    fileprivate(set) var error: Error? {
        didSet { onChange?(.error(error)) }
    }
}

final class PhotoGalleryViewModel {

    /// State
    private let state = PhotoGalleryState()
    
    /// State change handler to trigger
    var stateChangeHandler: ((PhotoGalleryState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }

    /// Data controller
    private var dataController: PhotoGalleryDataProtocol

    /// Count of the image in images list
    var imagesCount: Int {
        return images?.count ?? 0
    }
    
    /// List of images data
    private var imagesDataList: [Data]? = []
    
    /// List of images
    private var images: [UIImage]? = []
    
    /// Initializes a new view model
    ///
    /// - Parameter dataController: Provided data controller
    init(with dataController: PhotoGalleryDataProtocol) {
        self.dataController = dataController
    }
}

// MARK: - Public

extension PhotoGalleryViewModel {
    
    /// Returns image data at given index
    ///
    /// - Parameter index: Index of the requested image
    /// - Returns: Image data if exists
    func imageData(at index: Int) -> Data? {
        guard index < imagesCount,
            let imageDate = imagesDataList?[index] else {
            return nil
        }
        return imageDate
    }
    
    /// Returns thumbnail imageat given index
    ///
    /// - Parameter index: Index of the requested image
    /// - Returns: Image if exists
    func thumbnailImage(at index: Int) -> UIImage? {
        guard index < imagesCount,
            let thumbnailImage = images?[index] else {
            return nil
        }
        
        return thumbnailImage
    }
    
    /// Add new image data
    ///
    /// - Parameter imageData: Image data of the new image
    func addNewImageData(_ imageData: Data) {
        self.addImageToImagesList(imageData: imageData)
        self.imagesDataList?.append(imageData)
        self.state.isNewImageAdded = true
    }
}

// MARK: - Networking

extension PhotoGalleryViewModel {
    
    /// Retrieves gallery photos
    func retrieveImages() {
        dataController.retrieveImagesData { [weak self] (imagesDataList, error) in
            
            self?.state.error = error
            
            if imagesDataList?.count == 0 {
               self?.state.availabilityMessage = "No photos available"
               self?.state.areImagesAvailable = false
            }
            else {
                self?.imagesDataList = imagesDataList
                guard let imagesDataList = imagesDataList else {
                    self?.state.areImagesAvailable = false
                    return
                }
                
                for imageData in imagesDataList {
                    self?.addImageToImagesList(imageData: imageData)
                }
                self?.state.areImagesAvailable = true
            }
        }
    }
}

// MARK: - Helpers

private extension PhotoGalleryViewModel {
    func addImageToImagesList(imageData: Data) {
        if let image = UIImage(data: imageData)?.resizeImage(targetSize: ImageSize.thumbnail) {
            self.images?.append(image)
        }
    }
}
