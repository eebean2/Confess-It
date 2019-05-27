//
//  UIView+Extension.swift
//  Confess It
//
//  Created by Erik Bean on 5/27/19.
//  Copyright © 2019 Brick Water Studios. All rights reserved.
//

import UIKit

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
