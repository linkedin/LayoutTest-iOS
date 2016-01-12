Project Structure
-----------------

The project is currently split into two CocoaPods: LayoutTestBase and LayoutTest.

LayoutTestBase contains most of the library (which is then split into subspecs), but doesn't contain anything with a dependency on XCTest. This allows applications to use LayoutTestBase in a runnable application. This is useful for using the catalog view controllers or just using some of the helpers.

LayoutTest depends on LayoutTestBase and contains all the files which require XCTest.

This is not the easiest setup to use because it requires you to import both frameworks when you use the library, but currently, we have not found a better way to setup the project.

Swift
=====

All the swift code is kept in a subspec. This subspec is NOT included automatically in the main import. This is intentional since it seems most apps wanting to use this library are written in Objective-C and don't want to deal with the pain of swift dependencies.

Subspecs
========

We considered using subspecs for the base code and XCTest dependent code, but couldn't because of this ticket: https://github.com/CocoaPods/CocoaPods/issues/4629
