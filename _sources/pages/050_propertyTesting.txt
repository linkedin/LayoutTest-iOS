Property Testing
----------------

This library is built of the idea of property testing. Property testing is basically when you create a bunch of inputs to a function and assert properties on the output. It gained popularity in Haskell with the QuickCheck library and in Scala with ScalaCheck.

For an overview of property based testing, see:

  Human Readable Description

  http://blog.jessitron.com/2013/04/property-based-testing-what-is-it.html

  Mathematical Definition

  http://en.wikipedia.org/wiki/Property_testing

Differences
===========

The main difference between this library and traditional property testing is that traditional property testing uses truly random input. For now, this library is deterministic, but takes the idea of running many combinations from property based testing.

Also, QuickCheck and ScalaTest attempt to provide the smallest possible input for a failure. So if it fails on an array of 100 elements, it will try it with some of the elements removed, and when it presents a failure will try to give the smallest input it failed on. This library does not attempt anything like that, but it's a good idea for the future.
