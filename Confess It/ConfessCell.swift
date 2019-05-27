//
//  ConfessCell.swift
//  Confess It
//
//  Created by Erik Bean on 5/26/19.
//  Copyright © 2019 Brick Water Studios. All rights reserved.
//

import UIKit

class ConfessCell: UITableViewCell {
    @IBOutlet weak var story: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var background: UIView!
    var confession: Confession!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        layer.cornerRadius = 5
//        layer.masksToBounds = true
//        contentView.backgroundColor = .black
        shareButton.setImage(UIImage(named: "Share")!, for: .normal)
    }
    
    @IBAction func didPressShare() {
        do {
//            try share(confession: confession)
            shareButton.isHidden = true
            try share(items: [contentView.asImage()])
            shareButton.isHidden = false
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
