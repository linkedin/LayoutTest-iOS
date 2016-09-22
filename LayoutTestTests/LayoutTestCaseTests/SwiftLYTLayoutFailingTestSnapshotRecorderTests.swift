// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutTest

class SwiftLYTLayoutFailingTestSnapshotRecorderTests: XCTestCase {
    
    func testStartNewLogDeletesExisitingClassSnapshotDirectory() {
        let fileManager = FileManager.default
        let currentDirectory = Bundle(for:type(of: self)).bundlePath
        let classDirectory = currentDirectory + "/LayoutTestImages/SwiftLYTLayoutFailingTestSnapshotRecorderTests"
        let testFilePath = classDirectory + "/testFile.html"
        do {
            try fileManager.createDirectory(atPath: classDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch{}
        fileManager.createFile(atPath: testFilePath, contents: nil, attributes: nil)
        
        let recorder = LYTLayoutFailingTestSnapshotRecorder()
        recorder.startNewLog(for: type(of: self))
        
        XCTAssertFalse(fileManager.fileExists(atPath: testFilePath))
    }
    
}
