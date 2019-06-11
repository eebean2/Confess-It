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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItemToProcess: UIApplicationShortcutItem?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        if shortcutItemToProcess != nil {
            if let root = window?.rootViewController as? UINavigationController {
                if let con = root.topViewController as? ConfessController {
                    con.performSegue(withIdentifier: "newConfession", sender: con)
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {}


}

