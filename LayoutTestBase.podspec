Pod::Spec.new do |spec|
  spec.name             = 'LayoutTestBase'
  spec.version          = '2.0.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutTest-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'Base library for LayoutTest without XCTest dependency. LayoutTest enables you to write unit tests which test the layout of views.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutTest-iOS.git', :tag => '2.0.0' }
  spec.platform         = :ios, '7.0'
  spec.frameworks       = 'Foundation', 'UIKit'
  spec.default_subspecs = 'Core', 'Autolayout', 'Catalog', 'Config', 'UIViewHelpers'

  spec.subspec 'Swift' do |sp|
    sp.dependency 'LayoutTestBase/Core'
    sp.dependency 'LayoutTestBase/Autolayout'
    sp.dependency 'LayoutTestBase/Catalog'
    sp.dependency 'LayoutTestBase/Config'
    sp.dependency 'LayoutTestBase/UIViewHelpers'
    sp.dependency 'LayoutTestBase/SwiftSubspec'
  end

  spec.subspec 'SwiftSubspec' do |sp|
    sp.source_files = 'LayoutTestBase/Swift/**/*'
    sp.dependency 'LayoutTestBase/Core'
    sp.dependency 'LayoutTestBase/ModuleHeader'
  end

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

  spec.subspec 'ModuleHeader' do |sp|
    sp.source_files = 'LayoutTestBase/LayoutTestBase.h'
  end
end
