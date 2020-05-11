//
//  ImageViewerViewController.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class ImageViewerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var imageView: UIImageView!
    
    /// View model
    var viewModel: ImageViewerViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.loadImage()
    }
}

// MARK: - Change Handler

private extension ImageViewerViewController {

    func bindViewModel() {
        viewModel.stateChangeHandler = { [unowned self] change in
            self.applyStateChange(change)
        }
    }

    func applyStateChange(_ change: ImageViewerState.Change) {
        switch change {
        case .image(let image):
            imageView.image = image
        }
    }
}

// MARK: - Actions

private extension ImageViewerViewController {
    
    @IBAction func rotateButtonTapped(_ sender: UIButton) {
        viewModel.rotateImage()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
