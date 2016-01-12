Pod::Spec.new do |spec|
  spec.name             = 'LayoutTestBase'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutTest-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'Base library for LayoutTest which contains no dependencies on XCTest. LayoutTest enables you to write unit tests which test the layout of a view in multiple configurations. It tests the view with different data combinations and different view sizes. The library works in both Objective-C and Swift.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutTest-iOS.git', :tag => '1.0.0' }
  spec.frameworks       = 'Foundation', 'UIKit'
  spec.default_subspecs = 'Core', 'Autolayout', 'Catalog', 'Config', 'UIViewHelpers'

  spec.subspec 'Core' do |sp|
    sp.source_files = 'LayoutTestBase/Core/**/*'
    sp.dependency 'LayoutTestBase/Config'
  end

  spec.subspec 'Autolayout' do |sp|
    sp.source_files = 'LayoutTestBase/Autolayout'
  end

  spec.subspec 'Catalog' do |sp|
    sp.source_files = 'LayoutTestBase/Catalog'
    sp.dependency 'LayoutTestBase/Core'
  end

  spec.subspec 'Config' do |sp|
    sp.source_files = 'LayoutTestBase/Config'
  end

  spec.subspec 'UIViewHelpers' do |sp|
    sp.source_files = 'LayoutTestBase/UIViewHelpers'
    sp.dependency 'LayoutTestBase/Config'
  end
end
