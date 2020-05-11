//
//  ImagePicker.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerDelegate: class {
    func imagePicker(_ imagePicker: ImagePicker, canUseCamera accessIsAllowed: Bool)
    func imagePicker(_ ImagePicker: ImagePicker, canUseGallery accessIsAllowed: Bool)
    func imagePicker(_ ImagePicker: ImagePicker, didSelectImage image: UIImage)
    func imagePickerDidCancel(_ ImagePicker: ImagePicker)
}

final class ImagePicker: NSObject {

    /// Properties
    private weak var imagePickerController: UIImagePickerController?
    private weak var presentingViewController: UIViewController?
    
    /// Delegate
    weak var delegate: ImagePickerDelegate? = nil

    /// Presents image picker
    ///
    /// - Parameter viewController: Presenting view controller
    /// - Parameter sourceType: Source type for the image
    func presentImagePicker(
        parent viewController: UIViewController,
        sourceType: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.imagePickerController = imagePickerController
        DispatchQueue.main.async {
            viewController.present(imagePickerController, animated: true, completion: nil)
        }
        presentingViewController = viewController
    }

    /// Dismisses presented image picker
    func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Permission requests

extension ImagePicker {

    /// Requests access to phone's camera
    func requestAccessToCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            DispatchQueue.main.async {
                self.delegate?.imagePicker(self, canUseCamera: true)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.delegate?.imagePicker(self, canUseCamera: accessGranted)
                }
            }
        }
    }
    
    /// Requests access to photo library
    func requestAccessToPhotos() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {
        case .authorized:
            self.delegate?.imagePicker(self, canUseGallery: true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                DispatchQueue.main.async {
                    let canUseGallery = newStatus == PHAuthorizationStatus.authorized
                    self.delegate?.imagePicker(self, canUseGallery: canUseGallery)
                }})
        default:
            self.delegate?.imagePicker(self, canUseGallery: false)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelectImage: image)
            return
        }

        if let image = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelectImage: image)
        } 
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.imagePickerDidCancel(self)
    }
}

// MARK: - UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate { }
