// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

enum SampleFailingViewError: Error {
    case invalidNib
}

open class SampleFailingView: UIView {

    private static let nibName = "SampleFailingView"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    class func loadFromNib() throws -> SampleFailingView {
        guard let viewInBundle = Bundle.main.loadNibNamed(
            SampleFailingView.nibName,
            owner: nil,
            options: nil),
              let sampleFailingView = viewInBundle.first as? SampleFailingView else {
            throw SampleFailingViewError.invalidNib
        }

        return sampleFailingView
    }

    func setup(_ json: [AnyHashable: Any]) {
        label.text = json["text"] as? String
        button.setTitle(json["buttonText"] as? String, for: .normal)
    }
}
