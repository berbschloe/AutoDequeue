Pod::Spec.new do |s|
    s.name = "AutoDequeue"
    s.version = "1.0.0"
    s.summary = "A type safe way to dequeue UITableView, UICollectionView, and MKMapView elements without having to call register."
    s.homepage = "https://github.com/berbschloe/AutoDequeue"
    s.license = "MIT"
    s.author = "Brandon Erbschloe"
    s.platform = :ios, "9.0"
    s.source = { :git => "https://github.com/berbschloe/AutoDequeue", :tag => "1.0.0" }
    s.source_files = "AutoDequeue", "AutoDequeue/**/*.{h,m,swift}"
end
