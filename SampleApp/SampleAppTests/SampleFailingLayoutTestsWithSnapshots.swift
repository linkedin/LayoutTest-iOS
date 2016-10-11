// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import SampleApp
import LayoutTest
import LayoutTestBase

class SampleFailingLayoutTestsWithSnapshots : LayoutTestCase {
    
    func testSampleFailingViewWithSnapshots() {
        runLayoutTests() { (view: SampleFailingView, data: [AnyHashable: Any], context: Any?) in
            // Expecting one of the auto-layout tests to fail when the really long string causes the label to overlap with the button
        }
    }
}

extension SampleFailingView : ViewProvider {
    public class func dataSpecForTest() -> [AnyHashable: Any] {
        return [
            "text": StringValues(),
            "buttonText": StringValues()
        ]
    }
    
    public class func view(forData data: [AnyHashable: Any], reuse reuseView: UIView?, size: ViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>?) -> UIView {
        let view = reuseView as? SampleFailingView ?? SampleFailingView.loadFromNib()
        view.setup(data)
        return view
    }
    
    public class func sizesForView() -> [ViewSize] {
        return [
            ViewSize(width: 300),
        ]
    }
}
