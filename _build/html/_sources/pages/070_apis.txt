Other APIs
----------

There are some other helper APIs to help you write tests quickly. As always, the code is the best place for up to date documentation.

Autolayout
==========

LYTAutolayoutFailureIntercepter - Globally detects when throws an error when laying out a view with Autolayout. This programmatically catches the errors you see in the console when you have too many constraints.

UIView Helpers
==============

UIView (LYTHelpers) - provides quick lookups for getting x, y, width, height etc.

UIView (LYTFrameComparison) - provides helpers for verifying relative frames of two views. This includes verifying the top is aligned or that one view is above another. It includes support for right to left languages.

UIView (LYTTestHelpers) - provides some common tests which most views should pass. These are run automatically when you subclass LYTLayoutTestCase or LayoutTestCase.
