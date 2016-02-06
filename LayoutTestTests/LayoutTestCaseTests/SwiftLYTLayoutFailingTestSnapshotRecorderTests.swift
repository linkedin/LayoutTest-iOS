//
//  SwiftLYTLayoutFailingTestSnapshotRecorderTests.swift
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import XCTest
import LayoutTest

class SwiftLYTLayoutFailingTestSnapshotRecorderTests: XCTestCase {
    
    func testStartNewLogDeletesExisitingClassSnapshotDirectory() {
        let fileManager = NSFileManager.defaultManager()
        let currentDirectory = NSBundle(forClass:self.dynamicType).bundlePath
        let classDirectory = currentDirectory.stringByAppendingString("/LayoutTestImages/SwiftLYTLayoutFailingTestSnapshotRecorderTests")
        let testFilePath = classDirectory.stringByAppendingString("/testFile.html")
        do {
            try fileManager.createDirectoryAtPath(classDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch{}
        fileManager.createFileAtPath(testFilePath, contents: nil, attributes: nil)
        
        let recorder = LYTLayoutFailingTestSnapshotRecorder()
        recorder.startNewLogForClass(self.dynamicType)
        
        XCTAssertFalse(fileManager.fileExistsAtPath(testFilePath))
    }
    
}
