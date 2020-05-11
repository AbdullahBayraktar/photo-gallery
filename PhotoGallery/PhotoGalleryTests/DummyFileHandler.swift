//
//  DummyFileHandler.swift
//  PhotoGalleryTests
//
//  Created by Abdullah Bayraktar on 10.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit
@testable import PhotoGallery

final class DummyFileHandler {
    static func storeDummyImage() {
        let image = UIImage(imageLiteralResourceName: "nature")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? FileHandler.store(
                    data: imageData,
                    forKey: ProcessInfo.processInfo.globallyUniqueString)
        }
    }
    
    
    static func removeImagesInDocumentDirectory() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                if fileURL.pathExtension == "jpeg" {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch  {
            print(error)
        }
    }
}
