//
//  PhotoGalleryViewModelTests.swift
//  PhotoGalleryViewModelTests
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import XCTest
@testable import PhotoGallery

private typealias ViewModel = PhotoGalleryViewModel
private typealias Change = PhotoGalleryState.Change

private class Box {

    let viewModel: ViewModel
    var changes: [Change] = []

    init(with dataController: PhotoGalleryDataProtocol = PhotoGalleryDummyDataController()) {
        viewModel = PhotoGalleryViewModel(with: dataController)
        viewModel.stateChangeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
}

final class PhotoGalleryViewModelTests: XCTestCase {

    private var error: Error?
    private var box: Box!

    override func setUp() {
        super.setUp()
        initializeBox()
    }

    private func initializeBox() {
        box = Box()
    }
}

// MARK: - Test Cases

extension PhotoGalleryViewModelTests {

    func testRetrieveImagesSuccessfully() {
        DummyFileHandler.storeDummyImage()
        
        let provider = PhotoGalleryDummyDataController()
        
        let box = Box(with: provider)
        box.viewModel.retrieveImages()

        XCTAssert(box.changes[0] == Change.error(nil))
        XCTAssert(box.changes[1] == Change.images(true))
    }
    
    func testRetrieveImagesWithNoImageSaved() {

        DummyFileHandler.removeImagesInDocumentDirectory()
        
        let provider = PhotoGalleryDummyDataController()
        let box = Box(with: provider)

        box.viewModel.retrieveImages()

        XCTAssert(box.changes[0] == Change.error(nil))
        XCTAssert(box.changes[1] == Change.empty(message: "No photos available"))
        XCTAssert(box.changes[2] == Change.images(false))
    }
    
    func testRetrieveImagesFailed() {

        let provider = PhotoGalleryDummyBrokenDataController()
        let box = Box(with: provider)
        
        box.viewModel.retrieveImages()

        let error = NSError(domain:"",
                            code:-1,
                            userInfo:[ NSLocalizedDescriptionKey: "The data couldn’t be read because it isn’t in the correct format."])
        
        XCTAssert(box.changes[0] == Change.error(error))
        XCTAssert(box.changes[1] == Change.images(false))
    }
    
    func testAddNewImage() {
        let provider = PhotoGalleryDummyDataController()
        let box = Box(with: provider)

        let image = UIImage(imageLiteralResourceName: "nature")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            box.viewModel.addNewImageData(imageData)
        }
        
        XCTAssert(box.changes[0] == Change.newImage(true))
    }
}

// MARK: - Equatable Extensions

extension PhotoGalleryState.Change: Equatable {

    public static func == (lhs: PhotoGalleryState.Change,
                           rhs: PhotoGalleryState.Change) -> Bool {
        switch (lhs, rhs) {
        case let ((.images(lhsState)),
                  (.images(rhsState))):
            return lhsState == rhsState
        case let ((.newImage(lhsState)),
                  (.newImage(rhsState))):
            return lhsState == rhsState
        case let ((.empty(lhsState)),
                  (.empty(rhsState))):
            return lhsState == rhsState
        case let ((.error(lhsError)),
                  (.error(rhsError))):
            return lhsError?.localizedDescription == rhsError?.localizedDescription
        default:
            return false
        }
    }
}
