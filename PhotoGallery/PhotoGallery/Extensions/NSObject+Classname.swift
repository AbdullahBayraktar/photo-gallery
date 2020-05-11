//
//  NSObject+Classname.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 4.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
