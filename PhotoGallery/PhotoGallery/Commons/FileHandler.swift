//
//  FileHandler.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 6.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class FileHandler {
    
    static func store(data: Data, forKey key: String) throws {
        if let filePath = FileHandler.filePath(forKey: key) {
            try? data.write(to: filePath)
        }
    }
    
    static func retrieveImagesData() -> [Data] {
        var imagesData: [Data] = []
        
        if let urls = FileHandler.orderedFileURLs(for: .documentDirectory) {
            for url in urls {
                if let fileData = FileManager.default.contents(atPath: url.path) {
                    imagesData.append(fileData)
                }
            }
        }
        
        return imagesData
    }
}

private extension FileHandler {
    static func filePath(forKey key: String) -> URL? {
        guard let documentURL = FileManager.default.urls(
            for: .documentDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask).first else {
                return nil
        }

        return documentURL.appendingPathComponent(key + ".jpeg")
    }

    static func fileUrls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool) -> [URL]? {
        let documentsURL = FileManager().urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? FileManager().contentsOfDirectory(at: documentsURL,
                                                              includingPropertiesForKeys: [],
                                                              options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }

    static func orderedFileURLs(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true) -> [URL]? {

        let fileUrls = FileHandler.fileUrls(for: .documentDirectory, skipsHiddenFiles: skipsHiddenFiles)
        let orderedFilePaths = fileUrls?.sorted(by: { (firstURL: URL, secondURL: URL) -> Bool in
             do {
                 let firstValues = try firstURL.resourceValues(forKeys: [.contentModificationDateKey])
                 let secondValues = try secondURL.resourceValues(forKeys: [.contentModificationDateKey])

                 if let firstDate = firstValues.contentModificationDate, let secondDate = secondValues.contentModificationDate {
                     return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
                 }
             } catch _{
                // TODO: Hanlde error case
             }
            return true
         })
        
        return orderedFilePaths
    }
}
