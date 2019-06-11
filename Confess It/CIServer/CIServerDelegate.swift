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

public protocol CIServerDelegate: class {
    func didFailShare(_ error: Error)
    func confessionDidUpdate()
    func confessionUpdateError(_ error: Error)
    func reportDidSucceed()
    func reportDidFail(_ error: Error)
}

public protocol CIPostDelegate: class {
    func postDidSucceed()
    func postDidFail(error: Error)
}
