Pod::Spec.new do |s|
  s.name         = "HaidoraQRScanningView"
  s.version      = "1.0"
  s.summary      = "a custom scanningView"

  s.description  = <<-DESC
                   A longer description of HaidoraBase in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/Haidora/HaidoraQRScanningView"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  
  s.author             = { "mrdaios" => "mrdaios@gmail.com" }

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/Haidora/HaidoraQRScanningView.git", :tag => s.version.to_s }

  s.source_files = 'Source/**/*.{h,m}'
  s.dependency "ZXingObjC", "~> 3.0.0"
  s.requires_arc = true

end