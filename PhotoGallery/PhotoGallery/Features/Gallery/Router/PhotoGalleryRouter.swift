//
//  PhotoGalleryRouter.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class PhotoGalleryRouter: Routable {
    
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?)
    {
        guard let route = PhotoGalleryViewController.Route(rawValue: routeID) else {
            return
        }
        
        switch route {
        case .imageSelection:
            let viewController: ImageViewerViewController = ImageViewerViewController.instantiate(appStoryboard: .main)
            
            if let parameters = parameters as? UIImage {
                let viewModel = ImageViewerViewModel(with: parameters)
                viewController.viewModel = viewModel
            }
            
            viewController.modalPresentationStyle = .fullScreen
            context.navigationController?.present(viewController, animated: false, completion: nil)
        }
    }
}
