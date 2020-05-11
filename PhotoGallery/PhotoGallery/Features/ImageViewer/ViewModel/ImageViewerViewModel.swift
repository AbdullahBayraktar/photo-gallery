//
//  ImageViewModel.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class ImageViewerState {

    /// Possible changes
    enum Change {
        case image(UIImage?)
    }

    /// Triggered when change occured
    var onChange: ((ImageViewerState.Change) -> Void)?

    /// Image state
    fileprivate(set) var image: UIImage? {
        didSet { onChange?(.image(image)) }
    }
}

final class ImageViewerViewModel {
    
    /// State
    private let state = ImageViewerState()
    
    /// State change handler to trigger
    var stateChangeHandler: ((ImageViewerState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }
    
    /// Selected image
    var image: UIImage?

    /// Initializes a new view model
    ///
    /// - Parameter dataSource: Provided data source
    init(with dataSource: UIImage) {
        self.image = dataSource
    }
    
    /// Loads image
    func loadImage() {
        state.image = image
    }
    
    /// Rotates image
    func rotateImage() {
        state.image = state.image?.rotate(radians: .pi/2)
    }
    
}
