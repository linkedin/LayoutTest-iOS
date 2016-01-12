Getting Started
---------------

The library is distributed using CocoaPods. You can install by adding the following to your Podfile.

Objective-C
===========

.. code-block:: ruby

  target :MyAppNameTests do
    pod 'LayoutTest'
  end

Swift
=====

.. code-block:: ruby

  target :MyAppNameTests do
    pod 'LayoutTest/Swift'
  end

Adding To Non-UnitTest Targets
==============================

.. NOTE::
  Since LayoutTestCase depends on XCTest, you should only add this pod to your unit tests target. If you want to use some of the functionality in an app (ie. catalog functionality or helpers), then you can include the LayoutTestBase pod in those targets.

For example:

.. code-block:: ruby

  target :MyAppName do
    pod 'LayoutTestBase'
  end

  target :MyAppNameTests do
    pod 'LayoutTest'
  end

Writing Tests
=============

See :doc:`020_writingTest`
