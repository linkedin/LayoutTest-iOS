// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import LayoutTest
import LayoutTestBase

/**
 This test mostly just verifies that the Swift class works correctly.
*/
class SwiftTest: LayoutTestCase {

    let exponentialCombinations = LYTIntegerValues().numberOfValues() * LYTIntegerValues().numberOfValues()
    let polynomialCombinations = (LYTIntegerValues().numberOfValues() * 2 - 1)

    func testBasicTests() {
        var timesCalled = 0
        runLayoutTests { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations * 2)
    }

    func testWithLimitResultsCombinations() {
        var timesCalled = 0
        runLayoutTests(limitResults: .limitDataCombinations) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations * 2)
    }

    func testWithLimitResultsSizes() {
        var timesCalled = 0
        runLayoutTests(limitResults: .noSizes) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations)
    }

    func testWithLimitResultsCombinationsAndSizes() {
        var timesCalled = 0
        runLayoutTests(limitResults: [.limitDataCombinations, .noSizes]) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations)
    }

    func testBasicMoreGenericTests() {
        var timesCalled = 0
        runLayoutTests(withViewProvider: NonViewCreationProtocol.self) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations * 2)
    }

    func testBasicMoreGenericTestsWithLimitResultsCombinations() {
        var timesCalled = 0
        runLayoutTests(withViewProvider: NonViewCreationProtocol.self, limitResults: .limitDataCombinations) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations * 2)
    }

    func testBasicMoreGenericTestsWithLimitResultsSizes() {
        var timesCalled = 0
        runLayoutTests(withViewProvider: NonViewCreationProtocol.self, limitResults: .noSizes) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations)
    }

    func testBasicMoreGenericTestsWithLimitResultsCombinationsAndSizes() {
        var timesCalled = 0
        runLayoutTests(withViewProvider: NonViewCreationProtocol.self, limitResults: [.limitDataCombinations, .noSizes]) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled += 1;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations)
    }

    class TestView: UIView, LYTViewProvider {
        @objc static func dataSpecForTest() -> [AnyHashable: Any] {
            return [
                "context": LYTIntegerValues(),
                "otherVariable": LYTIntegerValues()
            ]
        }

        static func view(forData data: [AnyHashable: Any], reuse reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>?) -> UIView {
            // Let's verify that this context works correctly
            context?.pointee = data["context"] as AnyObject?
            return TestView()
        }

        @objc static func sizesForView() -> [LYTViewSize] {
            return [
                LYTViewSize(width: iPhone6Width),
                LYTViewSize(width: iPadWidth)
            ]
        }
    }

    /**
    This is identical to TestView, but it doesn't implement the view creation protocol.
    */
    class NonViewCreationProtocol: NSObject, LYTViewProvider {
        @objc static func dataSpecForTest() -> [AnyHashable: Any] {
            return [
                "context": LYTIntegerValues(),
                "otherVariable": LYTIntegerValues()
            ]
        }

        @objc static func view(forData data: [AnyHashable: Any], reuse reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>?) -> UIView {
            // Let's verify that this context works correctly
            context?.pointee = data["context"] as AnyObject?
            return TestView()
        }

        @objc static func sizesForView() -> [LYTViewSize] {
            return [
                LYTViewSize(width: iPhone6Width),
                LYTViewSize(width: iPadWidth)
            ]
        }
    }
}
