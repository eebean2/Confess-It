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

public extension UIColor {
    
    var stringValue: String? {
        if let comp = self.cgColor.components {
            return "[\(comp[0]), \(comp[1]), \(comp[2]), \(comp[3])]"
        } else { return nil }
    }
    
    convenience init(from string: String) {
        let filteredString = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let comp = filteredString.components(separatedBy: ", ")
        self.init(red:      CGFloat((comp[0] as NSString).floatValue),
                  green:    CGFloat((comp[1] as NSString).floatValue),
                  blue:     CGFloat((comp[2] as NSString).floatValue),
                  alpha:    CGFloat((comp[3] as NSString).floatValue))
    }
    
}
