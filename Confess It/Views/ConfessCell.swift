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

class ConfessCell: UITableViewCell {
    @IBOutlet weak var story: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var background: UIView!
    var confession: Confession!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shareButton.setImage(UIImage(named: "Share")!, for: .normal)
    }
    
    @IBAction func didPressShare() {
        shareButton.isHidden = true
        CIServer().share([contentView.asImage()])
        shareButton.isHidden = false
    }
}
