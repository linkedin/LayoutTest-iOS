Overview
--------

This library helps you quickly write unit tests which test the layout of your views. These tests are run as part of your unit test suite. It is a property-based testing library, so it will run each test multiple times with different inputs.

Why Use This Library?
=====================

  1. It's easy to write layout tests for views in just a few lines of code.
  2. It's much faster to write than a UI automation test.
  3. It automatically tests for all kinds of edge cases you may have not considered when writing your view.
  4. The tests run fast (they're just unit tests).
  5. The tests are stable and deterministic.
  6. The library helps stop regressions in your layout logic.

What this Library doesn't do
============================

  1. This library doesn't test flows. You can't test tap targets or view transitions. For this, you'll need to use UI automation tests.
  2. This library doesn't take screenshots of views and compare them. Instead, you are checking properties of the UIView object for correctness.

General Flow
============

  1. You define a spec for the data that should inflate this view. Effectively, this is mock data.
  2. You define how the view gets built. This is usually a couple of lines of code (init and inflate).
  3. You write your tests by asserting properties on the view that should always be true. For example, you may check that one view's width is the same as another. You should check any layout logic which you've added to your view class.
  4. The testing framework creates many combinations of the data and inflates the view multiple times running the tests each time. In this way, you can write one test which tests hundreds of edge cases with no extra work. These edge cases include
