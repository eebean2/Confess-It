//
//  Confession.swift
//  Confess It
//
//  Created by Erik Bean on 5/26/19.
//  Copyright © 2019 Brick Water Studios. All rights reserved.
//

import UIKit
import Firebase

private let kBetaNotice = "From Confess It [Beta] - Share deepest secrets and nobody will know!"

public struct Confession {
    let referance: DocumentReference?
    let author: String?
    let story: String!
    let published: Date!
    let background: UIColor!
    
    init(referance: DocumentReference? = nil, author: String, story: String, pubished: Date?, background: UIColor?) {
        self.referance = referance
        self.author = author
        self.story = story
        self.published = pubished ?? Date()
        self.background = background ?? .black
    }
    
    init(story: String) {
        self.referance = nil
        self.author = "Confess It"
        self.story = story
        self.published = Date()
        self.background = .darkText
    }
    
    var shareString: String {
        if author != nil {
            return story + "\n" + author! + "\n" + kBetaNotice
        } else {
            return story + "\n- Anonymous\n" + kBetaNotice
        }
    }
}
