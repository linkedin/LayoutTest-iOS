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
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations * 2)
    }

    func testWithLimitResultsCombinations() {
        var timesCalled = 0
        runLayoutTests(limitResults: .LimitDataCombinations) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations * 2)
    }

    func testWithLimitResultsSizes() {
        var timesCalled = 0
        runLayoutTests(limitResults: .NoSizes) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations)
    }

    func testWithLimitResultsCombinationsAndSizes() {
        var timesCalled = 0
        runLayoutTests(limitResults: [.LimitDataCombinations, .NoSizes]) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations)
    }

    func testBasicMoreGenericTests() {
        var timesCalled = 0
        runLayoutTestsWithViewProvider(NonViewCreationProtocol.self) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations * 2)
    }

    func testBasicMoreGenericTestsWithLimitResultsCombinations() {
        var timesCalled = 0
        runLayoutTestsWithViewProvider(NonViewCreationProtocol.self, limitResults: .LimitDataCombinations) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations * 2)
    }

    func testBasicMoreGenericTestsWithLimitResultsSizes() {
        var timesCalled = 0
        runLayoutTestsWithViewProvider(NonViewCreationProtocol.self, limitResults: .NoSizes) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, exponentialCombinations)
    }

    func testBasicMoreGenericTestsWithLimitResultsCombinationsAndSizes() {
        var timesCalled = 0
        runLayoutTestsWithViewProvider(NonViewCreationProtocol.self, limitResults: [.LimitDataCombinations, .NoSizes]) { (view: TestView, data, context) in
            XCTAssertTrue(LYTIntegerValues().values.contains { $0 as? Int == context as? Int })
            timesCalled++;
        }
        XCTAssertEqual(timesCalled, polynomialCombinations)
    }

    class TestView: UIView, LYTViewProvider {
        @objc static func dataSpecForTest() -> [NSObject : AnyObject] {
            return [
                "context": LYTIntegerValues(),
                "otherVariable": LYTIntegerValues()
            ]
        }

        static func viewForData(data: [NSObject : AnyObject], reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> UIView {
            // Let's verify that this context works correctly
            context.memory = data["context"]
            return TestView()
        }

        @objc static func sizesForView() -> [LYTViewSize] {
            return [
                LYTViewSize(width: LYTiPhone6Width),
                LYTViewSize(width: LYTiPadWidth)
            ]
        }
    }

    /**
    This is identical to TestView, but it doesn't implement the view creation protocol.
    */
    class NonViewCreationProtocol: NSObject, LYTViewProvider {
        @objc static func dataSpecForTest() -> [NSObject : AnyObject] {
            return [
                "context": LYTIntegerValues(),
                "otherVariable": LYTIntegerValues()
            ]
        }

        @objc static func viewForData(data: [NSObject : AnyObject], reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> UIView {
            // Let's verify that this context works correctly
            context.memory = data["context"]
            return TestView()
        }

        @objc static func sizesForView() -> [LYTViewSize] {
            return [
                LYTViewSize(width: LYTiPhone6Width),
                LYTViewSize(width: LYTiPadWidth)
            ]
        }
    }
}
