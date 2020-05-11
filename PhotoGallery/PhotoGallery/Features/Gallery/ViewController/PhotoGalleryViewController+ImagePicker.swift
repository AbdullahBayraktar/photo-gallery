//
//  PhotoGalleryViewController+ImagePicker.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 6.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import  UIKit

// MARK: - ImagePickerDelegate

extension PhotoGalleryViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, canUseCamera accessIsAllowed: Bool) {
        if accessIsAllowed {
            imagePicker.presentImagePicker(parent: self, sourceType: .camera)
        } else {
            showPhoneSettings()
        }
    }
    
    func imagePicker(_ ImagePicker: ImagePicker, canUseGallery accessIsAllowed: Bool) {
        if accessIsAllowed {
            imagePicker.presentImagePicker(parent: self, sourceType: .photoLibrary)
        } else {
            showPhoneSettings()
        }
    }
    
    func imagePicker(_ ImagePicker: ImagePicker, didSelectImage image: UIImage) {
        
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            DispatchQueue.global().async {
               do {
                   try FileHandler.store(data: jpegData, forKey: UUID().uuidString)//ProcessInfo.processInfo.globallyUniqueString)
               } catch let error {
                   self.showAlertController(message: error.localizedDescription)
               }
            }
            viewModel.addNewImageData(jpegData)
        }
        
        imagePicker.dismiss()
    }
    
    func imagePickerDidCancel(_ ImagePicker: ImagePicker) {
        imagePicker.dismiss()
    }
}

// MARK: - App Settings

private extension PhotoGalleryViewController {
    func showPhoneSettings() {
        let alertController = UIAlertController(
            title: "Permission denied",
            message: "Please allow PhotoGallery app permissions through Settings in your phone",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })

        present(alertController, animated: true)
    }
}
