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

import MapKit

extension MKAnnotationView {

    /// A standardized reuse identifier to use with dequeueing annotation views.
    @objc open class var reuseIdentifier: String {
        return "\(String(reflecting: self)).ReuseIdentifier"
    }
}

extension MKMapView {

    /// Auto dequeues a reusable annotation view for the provided annotation.
    public func dequeueReusableAnnotationView<T: MKAnnotationView>(for annotation: MKAnnotation) -> T {
        let identifier = T.reuseIdentifier

        if #available(iOS 11.0, *) {
            if annotationViewRegistry.insert(identifier).inserted {
                register(T.self, forAnnotationViewWithReuseIdentifier: identifier)
            }

            guard let annotationView = dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation) as? T else {
                fatalError("No reusable annotation of type \(T.self) is registered with identifier \(identifier) for annotation \(annotation)")
            }

            return annotationView
        } else {
            guard let optionalAnnotationView = dequeueReusableAnnotationView(withIdentifier: identifier) as? T? else {
                fatalError("Reusable annotation of type \(T.self) is not registered with identifier \(identifier)")
            }

            guard let annotationView = optionalAnnotationView else {
                return T(annotation: annotation, reuseIdentifier: identifier)
            }

            annotationView.annotation = annotation
            
            return annotationView
        }
    }

    private static var annotationViewRegistryKey: UInt8 = 0
    private var annotationViewRegistry: Set<String> {
        get { return (objc_getAssociatedObject(self, &MKMapView.annotationViewRegistryKey) as? Set<String>) ?? [] }
        set { objc_setAssociatedObject(self, &MKMapView.annotationViewRegistryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
