//
//  Share.swift
//  Confess It
//
//  Created by Erik Bean on 5/26/19.
//  Copyright © 2019 Brick Water Studios. All rights reserved.
//

import UIKit
import Firebase

/// Generate an error code
///
/// CODES: 1-- Share
///        2-- Firebase
///        3-- Recoverable Unknown
private func error(code: Int, desciption: String) -> Error {
    return NSError(domain: "bws.confess.app", code: code, userInfo: [NSLocalizedDescriptionKey: desciption]) as Error
}

/// Share a confession
public func share(confession: Confession) throws {
    let shareSheet = UIActivityViewController(activityItems: [confession.shareString], applicationActivities: nil)
    if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        if let top = root.topViewController {
            top.present(shareSheet, animated: true, completion: nil)
        } else { throw error(code: 101, desciption: "Could not find top controller") }
    } else { throw error(code: 100, desciption: "Could not find navigation controller") }
}

public func share(items: [UIImage]) throws {
    let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        if let top = root.topViewController {
            top.present(shareSheet, animated: true, completion: nil)
        } else { throw error(code: 101, desciption: "Could not find top controller") }
    } else { throw error(code: 100, desciption: "Could not find navigation controller") }
}

private let db = Firestore.firestore()
public var confessions = [Confession]()

public func subscribe(pulse: @escaping () -> Void) {
    db.collection("confessions").addSnapshotListener { docSnap, error in
        guard let doc = docSnap else {
            print("Error: \(error?.localizedDescription ?? "[error not found]")")
            return
        }
        for d in doc.documentChanges {
            let dat = d.document.data()
            if let story = dat["story"] as? String {
                var time: Date
                if let t = dat["published"] as? Timestamp {
                    time = t.dateValue()
                } else { time = Date() }
                var author: String
                if let a = dat["author"] as? String {
                    author = a
                } else { author = "Anonymous" }
                var color: UIColor
                if let c = dat["background"] as? String {
                    color = UIColor(from: c)
                } else {
                    color = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
                }
                let conf = Confession(referance: d.document.reference, author: author, story: story, pubished: time, background: color)
                confessions.append(conf)
            } else { continue }
            confessions.sort(by: { $0.published > $1.published })
            pulse()
        }
    }
}


public func post(author: String, story: String, color: UIColor, completion: @escaping (Error?) -> Void) {
    db.collection("confessions").document().setData([
        "author": author,
        "story": story,
        "background": color.stringValue ?? UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1).stringValue!,
        "published": Timestamp(date: Date())
    ]) { error in
        completion(error)
    }
}

//public func report(confession: Confession) {
//    
//}
