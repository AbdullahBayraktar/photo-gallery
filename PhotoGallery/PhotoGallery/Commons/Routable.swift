//
//  Routable.swift
//  PhotoGallery
//
//  Created by Abdullah Bayraktar on 8.05.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

protocol Routable {
    
    /**
     Routes to the Screen specified by routeId.
     
     - Parameter routeID: Screen to be routed to.
     - Parameter context: The current view controller.
     - Parameter parameters: Any data or model that should be passed to the next view controller.
     */
    
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?)
}
