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

extension UICollectionReusableView {

    /// A standardized reuse identifier to use with dequeueing cells.
    @objc open class var reuseIdentifier: String {
        return "\(String(reflecting: self)).ReuseIdentifier"
    }

    /// A standardized reuse identifier to use with dequeueing supplementary view.
    @objc open class var supplementaryElementKind: String {
        return UICollectionView.elementKindSectionHeader
    }
}

extension UICollectionView {

    /// Auto dequeues a reusable cell for the provided index path.
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = T.reuseIdentifier
        if cellRegistry.insert(identifier).inserted {
            register(T.self, forCellWithReuseIdentifier: identifier)
        }

        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("No reusable cell of type \(T.self) is registered with identifier \(identifier) for indexPath \(indexPath)")
        }

        return cell
    }

    private static var cellRegistryKey: UInt8 = 0
    private var cellRegistry: Set<String> {
        get { return (objc_getAssociatedObject(self, &UICollectionView.cellRegistryKey) as? Set<String>) ?? [] }
        set { objc_setAssociatedObject(self, &UICollectionView.cellRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UICollectionView {

    /// Auto dequeues a reusable supplementary view of the given kind for the provided index path..
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String = T.supplementaryElementKind, for indexPath: IndexPath) -> T {
        let identifier = T.reuseIdentifier
        if reusableSupplementaryViewRegistry.insert(T.reuseIdentifier).inserted {
            register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }

        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("No supplementary view of type \(T.self) is registered with identifier \(identifier) of kind \(kind)")
        }

        return view
    }

    private static var reusableSupplementaryViewRegistryKey: UInt8 = 0
    private var reusableSupplementaryViewRegistry: Set<String> {
        get { return (objc_getAssociatedObject(self, &UICollectionView.reusableSupplementaryViewRegistryKey) as? Set<String>) ?? [] }
        set { objc_setAssociatedObject(self, &UICollectionView.reusableSupplementaryViewRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
