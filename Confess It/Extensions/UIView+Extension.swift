/*
 * Confess It
 *
 * This app is provided as-is with no warranty or guarantee
 * See the license file under "Confess It" -> "License" ->
 * "License.txt"
 *
 * Copyright © 2019 Brick Water Studios
 *
 */

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
