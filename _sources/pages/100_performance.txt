Performance
-----------

Since a simple test can run hundreds or thousands of times, sometimes these tests can start to run slowly. There are multiple ways to make the tests run faster.

How many times will it run?
===========================

Currently, the number of test runs will be:

::

  number_of_combinations_from_data_spec * number_of_sizes_to_test

You can limit the number of test runs by decreasing either of these values.

Limit LYTDataValues
===================

The more LYTDataValues subclasses you use in the data spec, the more tests will get run. You should only use LYTDataValues subclasses for things you actually want to test. For opaque values which don't really matter or don't affect layout (eg. id fields, tracking tokens), you may want to consider hard coding a single value.

Limit Results API
=================

When running tests, you can also pass in a limitResults flag. See LYTTesterLimitResults in LYTLayoutPropertyTester.h for full documentation.

Currently, results can be limited in two different ways.

=======================
Limit Data Combinations
=======================

With this flag on, the library will not choose every combination of data from the data spec. Instead, it will choose each single value at least once, but not all combinations of values. This makes the number of combinations O(m*n) instead of O(m^n) where m is the number of values in each LYTDataValues subclass and n is the number of LYTDataValues subclasses in the data spec.

Effectively, with this flag on, we assume independence of the data values. So, we assume that only single value changes will cause test failures and not combinations of values. Of course, this isn't strictly true, but it can help you run tests with larger data specs easily without losing too many tests.

=============
No View Sizes
=============

This ignores the view sizes passed in and runs the test on one size (the original size of the view).
