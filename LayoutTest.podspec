Pod::Spec.new do |spec|
  spec.name             = 'LayoutTest'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutTest-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'LayoutTest enables you to write unit tests which test the layout of a view in multiple configurations.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutTest-iOS.git', :tag => '1.0.0' }
  spec.platform         = :ios
  spec.default_subspecs = 'TestCase'
  spec.dependency         'LayoutTestBase'

  spec.subspec 'Swift' do |sp|
    sp.dependency 'LayoutTestBase/Core'
    sp.dependency 'LayoutTestBase/Autolayout'
    sp.dependency 'LayoutTestBase/Catalog'
    sp.dependency 'LayoutTest/TestCase'
    sp.dependency 'LayoutTestBase/Config'
    sp.dependency 'LayoutTestBase/UIViewHelpers'
    sp.dependency 'LayoutTest/SwiftSubspec'
    sp.dependency 'LayoutTest/ModuleHeader'
  end

  spec.subspec 'TestCase' do |sp|
    sp.source_files = 'LayoutTest/TestCase'
    sp.dependency 'LayoutTestBase/Core'
    sp.dependency 'LayoutTestBase/Config'
    sp.dependency 'LayoutTest/ModuleHeader'
    sp.framework  = 'XCTest'
  end

  spec.subspec 'SwiftSubspec' do |sp|
    sp.source_files = 'LayoutTest/Swift'
    sp.dependency 'LayoutTest/TestCase'
    sp.dependency 'LayoutTest/ModuleHeader' 
  end

  spec.subspec 'ModuleHeader' do |sp|
    sp.source_files = 'LayoutTest/LayoutTest.h'
  end
end

