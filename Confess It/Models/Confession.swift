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
import Firebase

private let kBetaNotice = "From Confess It [Beta] - Share deepest secrets and nobody will know!"

public struct Confession {
    let referance: DocumentReference?
    let author: String?
    let story: String!
    let published: Date!
    let background: UIColor!
    var reports = 0
    
    init(referance: DocumentReference? = nil, author: String, story: String, pubished: Date?, background: UIColor?, reports: Int = 0) {
        self.referance = referance
        self.author = author
        self.story = story
        self.published = pubished ?? Date()
        self.background = background ?? .black
        self.reports = reports
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
    
    var diagString: String {
        return """
        -- Confession Diagnostic
        - ID: \(referance?.documentID ?? "")
        - Author: \(author ?? "unknown")
        - Published On: \(published.description(with: NSLocale.current))
        - Reported: \(reports)
        """
    }
}
