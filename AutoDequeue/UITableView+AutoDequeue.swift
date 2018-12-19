//
//  AutoDequeue
//
//  Copyright (c) 2018 - Present Brandon Erbschloe - https://github.com/berbschloe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension UITableViewCell {

    public static var reuseIdentifier: String {
        return "\(String(reflecting: self)).ReuseIdentifier"
    }
}

extension UITableViewHeaderFooterView {

    public static var reuseIdentifier: String {
        return "\(String(reflecting: self)).ReuseIdentifier"
    }
}

extension UITableView {

    public func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = T.reuseIdentifier
        if cellRegistry.insert(identifier).inserted {
            register(T.self, forCellReuseIdentifier: identifier)
        }

        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("No reusable cell of type \(T.self) is registered with identifier \(identifier)")
        }

        return cell
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = T.reuseIdentifier
        if cellRegistry.insert(identifier).inserted {
            register(T.self, forCellReuseIdentifier: identifier)
        }

        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("No reusable cell of type \(T.self) is registered with identifier \(identifier) for indexPath \(indexPath)")
        }

        return cell
    }

    private static var cellRegistryKey: UInt8 = 0
    private var cellRegistry: Set<String> {
        get { return (objc_getAssociatedObject(self, &UITableView.cellRegistryKey) as? Set<String>) ?? [] }
        set { objc_setAssociatedObject(self, &UITableView.cellRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UITableView {

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        let identifier = T.reuseIdentifier
        if headerFooterViewRegistry.insert(identifier).inserted {
            register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        }

        guard let reusableView = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("No reusable header footer view of type \(T.self) is registered with identifier \(identifier)")
        }

        return reusableView
    }

    private static var headerFooterViewRegistryKey: UInt8 = 0
    private var headerFooterViewRegistry: Set<String> {
        get { return (objc_getAssociatedObject(self, &UITableView.headerFooterViewRegistryKey) as? Set<String>) ?? [] }
        set { objc_setAssociatedObject(self, &UITableView.headerFooterViewRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
