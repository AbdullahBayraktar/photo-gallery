//
//  UIViewController+Instantiation.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

extension UIViewController {

    class func instantiate<T: UIViewController>(appStoryboard: Storyboard) -> T {

        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
