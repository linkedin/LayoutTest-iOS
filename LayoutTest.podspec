Pod::Spec.new do |spec|
  spec.name             = 'LayoutTest'
  spec.version          = '6.1.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/LayoutTest-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'LayoutTest enables you to write unit tests which test the layout of a view in multiple configurations.'
  spec.source           = { :git => 'https://github.com/linkedin/LayoutTest-iOS.git', :tag => spec.version }
  spec.platform         = :ios, '12.0'
  spec.default_subspecs = 'TestCase'
  spec.swift_version    = '5.0'

  spec.subspec 'Swift' do |sp|
    sp.dependency 'LayoutTest/SwiftSubspec'
  end

  spec.subspec 'TestCase' do |sp|
    sp.source_files = 'LayoutTest/TestCase'
    sp.dependency 'LayoutTestBase/Autolayout', #{spec.version}
    sp.dependency 'LayoutTestBase/Catalog', #{spec.version}
    sp.dependency 'LayoutTestBase/Config', #{spec.version}
    sp.dependency 'LayoutTestBase/Core', #{spec.version}
    sp.dependency 'LayoutTestBase/UIViewHelpers', #{spec.version}
    sp.framework  = 'XCTest'
  end

  spec.subspec 'SwiftSubspec' do |sp|
    sp.source_files = 'LayoutTest/Swift', 'LayoutTest/LayoutTest.h'
    sp.dependency 'LayoutTest/TestCase'
    sp.dependency 'LayoutTestBase/Swift', #{spec.version}
  end
end

