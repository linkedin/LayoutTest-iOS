Automatic Tests
---------------

When you subclass LYTLayoutTestCase or LayoutTestCase, a few tests are run automatically. These are tests that most views should pass. You can turn these off in the config or individually on each test.

No subviews overlap
===================

The test verifies that no sibling subviews are overlapping. This can often happen when something is calculated incorrectly. If this is intentional, you can add certain views to an exception set.

If there is just one subview you want to allow overlaps for, you can add it to viewsAllowingOverlap in the validation block of your test. If there is a certain class which internally has overlapping subviews (such as a custom button), you can add it to viewClassesAllowingSubviewErrors.

All subviews contained within superview
=======================================

The test verifies that no subview is out of bounds of it's superview. Again, you can add exceptions if this is intentional.

If there is just one subview you want to allow overlaps for, you can add it to viewsAllowingOverlap in the validation block of your test.

Autolayout is not ambiguous and doesn't throw errors
====================================================

The test verifies that Autolayout is not ambiguous and also checks that there are no errors from having too many constraints.

Accessibility sanity check
==========================

The test runs some basic accessibility sanity checks. These are not comprehensive, but will catch some common errors. These include:

  - All UIControl subclasses have accessibility labels set. This way, accessibility users will be able to interact with them. You can add to this list of classes by adding to viewClassesRequiringAccessibilityLabels.
  - All elements with accessibility identifiers also have accessibility labels. Otherwise, the identifiers will be read out.
  - No elements with accessibility labels are nested inside other elements with accessibility labels. Accessibility doesn't support nested elements, and nested elements are not reachable by accessibility users.

You can add views that allow accessibility errors to viewsAllowingAccessibilityErrors in the validation block.
