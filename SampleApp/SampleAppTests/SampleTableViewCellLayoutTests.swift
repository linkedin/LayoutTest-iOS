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

public func saveImage(image: UIImage, fileName: String) {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let directoryPath = documentsPath.stringByAppendingString("/snapshots")
    
    let imagePath = directoryPath.stringByAppendingString("/" + fileName + "_" + String(image.size.width) + "_" + String(image.size.height) + ".png")
    
    do {
        try NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: false, attributes: nil)
    } catch {}
    
    UIImageJPEGRepresentation(image,1.0)!.writeToFile(imagePath, atomically: true)
}

// If you are writing in Objective-C, you should use LYTLayoutTestCase instead
public func LYTAssertTrue(view: UIView, @autoclosure expression: () -> BooleanType, _ message: String = "", file: String = "", line: UInt = 0) {
    let result = expression();
    if (result.boolValue == false) {
        let image = renderLayer(view.layer)     //snapShot(view)
        saveImage(image, fileName: "snapshot")
    }
    XCTAssertTrue(result);
}

public func renderLayer(layer: CALayer) -> UIImage {
    let bounds = layer.bounds
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0);
    
    if let context: CGContext! = UIGraphicsGetCurrentContext() {
        CGContextSaveGState(context)
        layer.renderInContext(context!)
        CGContextRestoreGState(context)
    }
    
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return snapshot
}

class SampleTableViewCellLayoutTests : LayoutTestCase {

    let titleLabelLeftPadding: CGFloat = 8
    
    func testSampleTableViewCell() {
        runLayoutTests() { (view: SampleTableViewCell, data: [NSObject: AnyObject], context: Any?) in
            
            // Verify that the label and image view are top aligned
            //XCTAssertTrue(view, expression: view.titleLabel.lyt_bottomAligned(view.mainImageView))

            // Verify that the text gets set correctly
            XCTAssertEqual(view.titleLabel.text, data["text"] as? String)

            if view.mainImageView.hidden {
                // If the image view is hidden, then the title label should be 8 from the left edge (image should be squashed)
                XCTAssertEqual(view.titleLabel.lyt_left, self.titleLabelLeftPadding)
            } else {
                // If it is not hidden, then it should be 8 away from the right of the image view
                XCTAssertEqual(view.titleLabel.lyt_left, view.mainImageView.lyt_right + 8)
                // The image view should be before the title label
                XCTAssertTrue(view.mainImageView.lyt_before(view.titleLabel))
            }

            if view.rightButton.hidden {
                // If the right button is hidden, then the text label should be 8 from the right edge
                XCTAssertEqual(view.titleLabel.lyt_right, view.lyt_width - self.titleLabelLeftPadding)
            } else {
                // Otherwise, the text label should be right up against the button
                XCTAssertEqual(view.titleLabel.lyt_right, view.rightButton.lyt_left)
                // Here, I verify that the button's title is being set correctly
                XCTAssertEqual(view.rightButton.titleForState(.Normal), data["buttonText"] as? String)
            }

            // Verify that the right label is enabled iff the data specifies that it is enabled
            XCTAssertEqual(view.rightButton.enabled, data["buttonEnabled"] as? Bool ?? false)
            
            LYTAssertTrue(view, expression: view.titleLabel.lyt_topAligned(view.mainImageView))
        }
    }

}

extension SampleTableViewCell : LYTViewProvider {
    public class func dataSpecForTest() -> [NSObject: AnyObject] {
        return [
            "text": LYTStringValues(),
            "buttonText": LYTStringValues(),
            "buttonEnabled": LYTBoolValues(),
            "imageType": LYTDataValues(values: ["linkedin", "garbageString", NSNull()])
        ]
    }

    public class func viewForData(data: [NSObject: AnyObject], reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> UIView {
        let view = reuseView as? SampleTableViewCell ?? SampleTableViewCell.loadFromNib()
        view.setup(data)
        return view
    }

    // This is an optional method and can also be specified globally in the config.
    public class func sizesForView() -> [LYTViewSize] {
        return [
            // Test the view with a specific width
            LYTViewSize(width: 300),
            // Test the view with the same width as an iPhone 4
            LYTViewSize(width: LYTiPhone4Width),
            // Test the view by setting the width to the iPad width
            LYTViewSize(width: LYTiPadWidth),
            // Test the view by setting the width to the iPad height
            LYTViewSize(width: LYTiPadHeight)
        ]
    }
}
