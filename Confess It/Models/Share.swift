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

/// Relocated
private func error(code: Int, desciption: String) -> Error {
    return NSError(domain: "bws.confess.app", code: code, userInfo: [NSLocalizedDescriptionKey: desciption]) as Error
}

// Deprecatd
@available(*, deprecated, message: "Use CIServer().share(_:)")
public func share(confession: Confession) throws {
    let shareSheet = UIActivityViewController(activityItems: [confession.shareString], applicationActivities: nil)
    if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        if let top = root.topViewController {
            top.present(shareSheet, animated: true, completion: nil)
        } else { throw error(code: 101, desciption: "Could not find top controller") }
    } else { throw error(code: 100, desciption: "Could not find navigation controller") }
}

// Deprecated
@available(*, deprecated, message: "Reloacated to CIServer().share(_:)")
public func share(items: [UIImage]) throws {
    let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        if let top = root.topViewController {
            top.present(shareSheet, animated: true, completion: nil)
        } else { throw error(code: 101, desciption: "Could not find top controller") }
    } else { throw error(code: 100, desciption: "Could not find navigation controller") }
}

private let db = Firestore.firestore() // Relocated
public var confessions = [Confession]()

// Deprecated
@available(*, deprecated, message: "Reloacated to CIServer().subscribe()")
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
                if let r = dat["reports"] as? Int {
                    if r >= 5 {
                        moveAndRemove(confession: conf)
                        continue
                    }
                }
                confessions.append(conf)
            } else { continue }
            confessions.sort(by: { $0.published > $1.published })
            pulse()
        }
    }
}

// Deprecated
@available(*, deprecated)
private func moveAndRemove(confession: Confession) {
    
}

// Deprecated
@available(*, deprecated)
private func remove(document: DocumentReference, completion: @escaping (Bool) -> Void) {
    document.delete { error in
        if let error = error {
            print(error.localizedDescription)
            completion(false)
        } else {
            completion(true)
        }
    }
}

@available(*, deprecated, message: "Relocated to CIServer().post(_:, _:, _:)")
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

// Deprecated
@available(*, deprecated, message: "Relocated to CIServer().report(_:)")
public func report(confession: Confession, completion: (Bool) -> Void) {
    
}
