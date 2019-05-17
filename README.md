# AutoDequeue
[![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift/)
[![CocoaPods](https://img.shields.io/badge/pod-v1.1.0-blue.svg)](https://cocoapods.org/pods/AutoDequeue)

A type safe way to dequeue UITableView, UICollectionView, and MKMapView elements without having to call register.
Element registration, type casting, and error handling are all done inside a the single dequeue method for each view.

## Requirements

- iOS 9.0+
- Xcode 10.2+
- Swift 5.0+

## Instalation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate the library into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AutoDequeue', '1.1.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

```swift
dependencies: [
    .package(url: "https://github.com/berbschloe/AutoDequeue.git", from: "1.1.0")
]
```

## Usage

#### Importing
It would be recommended to add AutoDequeue globally because it can get annoying importing it everywhere.

```swift
// Add this to a GlobalImports.swift
@_exported import AutoDequeue
```

### How to use for UITableView

#### Old Way
```swift
func viewDidLoad() {
    super.viewDidLoad()
    // register elements by a reuse id
    tableView.register(CustomCell.self, forCellReuseIdentifier: "CELL_ID")
    tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "HEADER_ID")
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_ID", for: indexPath) as? CustomCell else {
        fatalError("Invalid Class")
    }
    
    // setup cell
    
    return cell
}

func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = dequeueReusableHeaderFooterView(withIdentifier: "HEADER_ID") as? CustomHeader else {
        fatalError("Invalid Class")
    }
    
    // setup header
    
    return header
}
```

#### AutoDequeue Way

```swift
func viewDidLoad() {
    super.viewDidLoad() 
    // no need to register elements
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CustomCell = tableView.dequeueReusableCell(for: indexPath)
    
    // setup cell
    
    return cell
}

func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header: CustomHeader = dequeueReusableHeaderFooterView()
    
    // setup header
    
    return header
}
```

### How to use for UICollectionView

#### Old Way

```swift
func viewDidLoad() {
    super.viewDidLoad()
    // register elements by a reuse id
    collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CELL_ID")
    collectionView.register(CustomHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HEADER_ID")
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = dequeueReusableCell(withReuseIdentifier: "CELL_ID", for: indexPath) as? CustomCell else {
        fatalError("Invalid Class")
    }
    
    // setup cell
    
    return cell
}

func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                    
     guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HEADER_ID", for: indexPath
       ) as? CustomHeader else {
            fatalError("Invalid Class")
       }
       
       // setup header
       
       return header
}
```

#### AutoDequeue Way

```swift
func viewDidLoad() {
    super.viewDidLoad()
    // no need to register elements
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CustomCell = dequeueReusableCell(for: indexPath)
    
    // setup cell
    
    return cell
}

func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header: CustomHeader = dequeueReusableSupplementaryView(for: indexPath)
       
    // setup header
       
    return header
}
```
### How to use for MKMapView

#### Old Way

```swift
func viewDidLoad() {
    super.viewDidLoad()
    // register elements by a reuse id
    mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ANNOTATION_ID")
}

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ANNOTATION_ID", for: annotation) as? CustomAnnotationView else {
        fatalError("Invalid Class")
    }
    
    return annotationView
}

```

#### AutoDequeue

```swift
func viewDidLoad() {
    super.viewDidLoad()
    // no need to register elements
}

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView: CustomAnnotationView = mapView.dequeueReusableAnnotationView(for annotation)
    return annotationView
```
