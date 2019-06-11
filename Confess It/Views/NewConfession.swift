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

var kKeyboardIsVisable: Bool = false

class NewConfession: UIViewController {
    
    @IBOutlet weak var story: UITextView!
    @IBOutlet weak var author: UITextField?
    @IBOutlet weak var storyBottom: NSLayoutConstraint!
    
    @IBOutlet var colors: [UIButton]!
    var selectedColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    let server = CIServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        server.postDelegate = self
        colors[2].layer.borderColor = UIColor.lightGray.cgColor
        story.layer.borderColor = UIColor.black.cgColor
        story.layer.borderWidth = 2
        story.layer.cornerRadius = 5
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func didPressCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSubmitConfession() {
        view.endEditing(true)
        if !valueCheck() {
            let alert = UIAlertController(title: "Oh No!", message: "You can not submit an empty confession!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        var a = author?.text
        if a == nil || a == "" {
            a = "Anonymous"
        }
        server.post(author: a!, story: story.text, color: selectedColor)
    }

    @objc
    func keyboardDidChange(notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frameInfo.cgRectValue
        UIView.animate(withDuration: 0.75, animations: {
            if kKeyboardIsVisable {
                self.storyBottom.constant -= keyboardFrame.height
            } else {
                self.storyBottom.constant += keyboardFrame.height
            }
        }) { _ in
            kKeyboardIsVisable.toggle()
        }
    }
    
    func valueCheck() -> Bool {
        if story.text != nil && story.text != "" {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func didSelectColor(sender: UIButton) {
        for color in colors { color.layer.borderColor = UIColor.clear.cgColor }
        sender.layer.borderColor = UIColor.lightGray.cgColor
        selectedColor = sender.backgroundColor!
    }
}

extension NewConfession: CIPostDelegate {
    func postDidSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func postDidFail(error: Error) {
        let alert = UIAlertController(title: "Oh No!", message: "You confession was so juicy, it broke our server!!! Please try again in a min!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
