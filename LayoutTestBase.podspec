Pod::Spec.new do |spec|
  spec.name             = 'LayoutTestBase'
  spec.version          = '5.0.2'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutTest-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'Base library for LayoutTest without XCTest dependency. LayoutTest enables you to write unit tests which test the layout of views.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutTest-iOS.git', :tag => spec.version }
  spec.platform         = :ios, '7.0'
  spec.frameworks       = 'Foundation', 'UIKit'
  spec.default_subspecs = 'Core', 'Autolayout', 'Catalog', 'Config', 'UIViewHelpers'
  spec.swift_version    = '5.0'

  spec.subspec 'Swift' do |sp|
    sp.source_files = 'LayoutTestBase/Swift/**/*', 'LayoutTestBase/LayoutTestBase.h'
    sp.dependency 'LayoutTestBase/Core'
    sp.dependency 'LayoutTestBase/Autolayout'
    sp.dependency 'LayoutTestBase/Catalog'
    sp.dependency 'LayoutTestBase/Config'
    sp.dependency 'LayoutTestBase/UIViewHelpers'
    sp.platform = :ios, '8.0'
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
end

