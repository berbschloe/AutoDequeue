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

import XCTest
import AutoDequeue
import MapKit

class TestTableViewCell: UITableViewCell {}
class TestTableViewHeaderFooterView: UITableViewHeaderFooterView {}

class TestCollectionViewCell: UICollectionViewCell {}
class TestCollectionReusableView: UICollectionReusableView {}

class TestAnnotationView: MKAnnotationView {}

class AutoDequeueTests: XCTestCase {

    func testReuseIdentifiable() {

        let moduleName = String(reflecting: type(of: self)).components(separatedBy: ".").first!

        XCTAssertEqual("UITableViewCell.ReuseIdentifier", UITableViewCell.reuseIdentifier)
        XCTAssertEqual("UITableViewHeaderFooterView.ReuseIdentifier", UITableViewHeaderFooterView.reuseIdentifier)

        XCTAssertEqual("\(moduleName).TestTableViewCell.ReuseIdentifier", TestTableViewCell.reuseIdentifier)
        XCTAssertEqual("\(moduleName).TestCollectionViewCell.ReuseIdentifier", TestCollectionViewCell.reuseIdentifier)

        XCTAssertEqual("UICollectionViewCell.ReuseIdentifier", UICollectionViewCell.reuseIdentifier)
        XCTAssertEqual("UICollectionReusableView.ReuseIdentifier", UICollectionReusableView.reuseIdentifier)

        XCTAssertEqual("\(moduleName).TestCollectionViewCell.ReuseIdentifier", TestCollectionViewCell.reuseIdentifier)
        XCTAssertEqual("\(moduleName).TestCollectionReusableView.ReuseIdentifier", TestCollectionReusableView.reuseIdentifier)

        XCTAssertEqual("MKAnnotationView.ReuseIdentifier", MKAnnotationView.reuseIdentifier)
        XCTAssertEqual("\(moduleName).TestAnnotationView.ReuseIdentifier", TestAnnotationView.reuseIdentifier)
    }


    func testRegistryPattern() {
        let testObject = NSObject()
        XCTAssertEqual(testObject.testRegistry, [])
        testObject.testRegistry.insert("Hello")
        XCTAssertEqual(testObject.testRegistry, ["Hello"])
        testObject.testRegistry.insert("World")
        XCTAssertEqual(testObject.testRegistry, ["Hello", "World"])
    }

    func testTableView() {
        let tableView = UITableView()

        _ = tableView.dequeueReusableCell()
        _ = tableView.dequeueReusableHeaderFooterView()
        _ = tableView.dequeueReusableCell(for: IndexPath())

        _ = tableView.dequeueReusableCell() as TestTableViewCell
        _ = tableView.dequeueReusableHeaderFooterView() as TestTableViewHeaderFooterView
    }

    func testCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        _ = collectionView.dequeueReusableCell(for: IndexPath())
        _ = collectionView.autoDequeueReusableSupplementaryView(for: IndexPath())

        _ = collectionView.dequeueReusableCell(for: IndexPath()) as TestCollectionViewCell
        _ = collectionView.autoDequeueReusableSupplementaryView(for: IndexPath()) as TestCollectionReusableView
    }

    func testMapView() {
        let mapView = MKMapView()

        _ = mapView.dequeueReusableAnnotationView(for: MKPointAnnotation())
        _ = mapView.dequeueReusableAnnotationView(for: MKPointAnnotation()) as TestAnnotationView
    }
}

extension NSObject {
    private static var testRegistryKey: UInt8 = 0

    var testRegistry: Set<String> {
        get { return objc_getAssociatedObject(self, &NSObject.testRegistryKey) as? Set<String> ?? [] }
        set { objc_setAssociatedObject(self, &NSObject.testRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

