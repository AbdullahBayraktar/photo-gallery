//
//  PhotoGalleryViewController.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class PhotoGalleryViewController: UIViewController {
    
    // MARK: Enums
    enum Route: String {
        case imageSelection
    }
    
    /// Outlets
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var messageLabel: UILabel!
    
    /// View model
    var viewModel: PhotoGalleryViewModel!
    
    /// Router
    var router: PhotoGalleryRouter!
    
    /// Image picker
    lazy var imagePicker = ImagePicker()

    // MARK: - Factory

    func initialize() {
        let dataController = PhotoGalleryDataController()
        viewModel = PhotoGalleryViewModel(with: dataController)
        router = PhotoGalleryRouter()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        prepareViews()
        bindViewModel()
        viewModel.retrieveImages()
    }
}

// MARK: - Views

private extension PhotoGalleryViewController {
    
    func prepareViews() {
        title = "Gallery"
        
        collectionView.register(cellType: PhotoGalleryCollectionViewCell.self, bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imagePicker.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
}

// MARK: - Change Handler

private extension PhotoGalleryViewController {

    func bindViewModel() {
        viewModel.stateChangeHandler = { [unowned self] change in
            self.applyStateChange(change)
        }
    }

    func applyStateChange(_ change: PhotoGalleryState.Change) {
        DispatchQueue.main.async {
            switch change {
                case .images(let available):
                    if available {
                        self.messageLabel.isHidden = !self.collectionView.isHidden
                        self.collectionView.reloadData()
                        self.scrollCollectionViewToBottom()
                    }
                case .newImage:
                    self.insertNewItemToCollectionView()
                    self.messageLabel.isHidden = !self.collectionView.isHidden
                case .empty(let message):
                    self.messageLabel.text = message
                    self.messageLabel.isHidden = false
                case .error(let error):
                    if let error = error {
                        self.showAlertController(message: error.localizedDescription)
                    }
            }
        }
    }
}

// MARK: - Actions

private extension PhotoGalleryViewController {
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController.init()
        
        let takeAPhotoAction = UIAlertAction(title: "Take a Photo", style: .default) { _ in
            self.imagePicker.requestAccessToCamera()
        }
        let uploadPhotoAction = UIAlertAction(title: "Upload from Phone Gallery", style: .default) { _ in
            self.imagePicker.requestAccessToPhotos()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(takeAPhotoAction)
        alertController.addAction(uploadPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: - AlertController

extension PhotoGalleryViewController {
    
    func showAlertController(message: String?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOKAction)
        self.present(alertController, animated: true)
    }
}


// MARK: - CollectionView

private extension PhotoGalleryViewController {
    
    func insertNewItemToCollectionView() {
        let lastIndexPath = IndexPath(row: self.viewModel.imagesCount-1, section: 0)
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [lastIndexPath])
        }, completion: { _ in
            self.scrollCollectionViewToBottom()
        })
    }
    
    func scrollCollectionViewToBottom() {
        let lastIndexPath = IndexPath(row: self.viewModel.imagesCount-1, section: 0)
        self.collectionView?.selectItem(at: lastIndexPath, animated: false, scrollPosition: .bottom)
    }
}
