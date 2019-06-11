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

import Foundation
import Firebase

public class CIServer {
    public weak var delegate: CIServerDelegate?
    public weak var postDelegate: CIPostDelegate?
    
    private let db = Firestore.firestore()
    
    /// CODES: 1-- Share
    ///        2-- Firebase
    ///        3-- Recoverable Unknown
    private func error(code: Int, desciption: String) -> Error {
        return NSError(domain: "bws.confess.app", code: code, userInfo: [NSLocalizedDescriptionKey: desciption]) as Error
    }
    
    // MARK: - Share -
    public func share(_ items: [UIImage]) {
        let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let top = root.topViewController {
                top.present(shareSheet, animated: true, completion: nil)
            } else {
                delegate?.didFailShare(error(code: 101, desciption: "Could not find top controller"))
            }
        } else {
            delegate?.didFailShare(error(code: 100, desciption: "Could not find navigation controller"))
        }
    }
    
    // MARK: - Post -
    public func post(author: String, story: String, color: UIColor) {
        db.collection("confessions").document().setData([
            "author": author,
            "story": story,
            "background": color.stringValue ?? UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1).stringValue!,
            "published": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                self.postDelegate?.postDidFail(error: error)
            } else {
                self.postDelegate?.postDidSucceed()
            }
        }
    }
    
    // MARK: - Subscribe -
    public func subscribe() {
        db.collection("confessions").addSnapshotListener { docSnap, error in
            if let error = error {
                self.delegate?.confessionUpdateError(error)
                return
            }
            guard let doc = docSnap else {
                self.delegate?.confessionUpdateError(self.error(code: 200, desciption: "No server data found"))
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
                    var reports = 0
                    if let r = dat["reports"] as? Int {
                        reports = r
                    }
                    let conf = Confession(referance: d.document.reference, author: author, story: story, pubished: time, background: color, reports: reports)
                    if reports >= 5 {
                        CIServer().moveAndRemove(conf)
                        continue
                    }
                    confessions.append(conf)
                } else { continue }
                confessions.sort(by: { $0.published > $1.published })
                self.delegate?.confessionDidUpdate()
            }
        }
    }
    
    // MARK: - Update -
    public func update(completion: @escaping (Bool) -> Void) {
        db.collection("confessions").getDocuments { snap, error in
            if let error = error {
                self.delegate?.confessionUpdateError(error)
                completion(false)
            }
            guard let snap = snap else {
                self.delegate?.confessionUpdateError(self.error(code: 200, desciption: "No server data found"))
                completion(false)
                return
            }
            var temp = [Confession]()
            for d in snap.documentChanges {
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
                    var reports = 0
                    if let r = dat["reports"] as? Int {
                        reports = r
                    }
                    let conf = Confession(referance: d.document.reference, author: author, story: story, pubished: time, background: color, reports: reports)
                    if reports >= 5 {
                        CIServer().moveAndRemove(conf)
                        continue
                    }
                    temp.append(conf)
                } else { continue }
            }
            confessions = temp
            completion(true)
        }
    }
    
    // MARK: - Report -
    public func report(_ confession: Confession) {
        if let ref = confession.referance {
            print(confession.diagString)
            let rep = confession.reports + 1
            ref.updateData(["reports":rep]) { error in
                if let error = error {
                    self.delegate?.reportDidFail(error)
                } else {
                    self.delegate?.reportDidSucceed()
                }
            }
        } else {
            let refError = error(code: 300, desciption: "Could not find confession database referance")
            delegate?.reportDidFail(refError)
        }
    }
    
    private func moveAndRemove(_ confession: Confession) {
        guard let ref = confession.referance else { abortRaM(confession); return }
        ref.getDocument { snap, error  in
            guard error == nil else { self.abortRaM(confession); return }
            guard let snap = snap, let data = snap.data() else { self.abortRaM(confession); return }
            self.db.collection("reported").addDocument(data: data) { error in
                guard error == nil else { self.abortRaM(confession); return }
                
            }
        }
    }
    
    private func remove(_ confession: Confession) {
        guard let ref = confession.referance else { abortRaM(confession); return }
        ref.delete { error in
            guard error == nil else { self.abortRaM(confession); return }
            self.delegate?.confessionDidUpdate()
        }
    }
    
    private func abortRaM(_ confession: Confession) {
        confessions.append(confession)
    }
}
