// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

public class SampleTableViewCell: UITableViewCell {

    private static let leftMaxEdge: CGFloat = 38
    private static let leftMinEdge: CGFloat = 0
    private static let buttonWidth: CGFloat = 80

    private static let nibName = "SampleTableViewCell"

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rightButton: UIButton!

    @IBOutlet private var labelLeftEdge: NSLayoutConstraint!
    @IBOutlet private var buttonWidth: NSLayoutConstraint!

    public class func registerForTableView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }

    public class func dequeueForTableView(tableView: UITableView, indexPath: NSIndexPath) -> SampleTableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(nibName, forIndexPath: indexPath) as! SampleTableViewCell
    }

    class func loadFromNib() -> SampleTableViewCell {
        let bun = NSBundle(forClass: self.classForCoder())
        return bun.loadNibNamed(SampleTableViewCell.nibName, owner: nil, options: nil)[0] as! SampleTableViewCell
    }

    func setup(json: [NSObject: AnyObject]) {
        let bun = NSBundle(forClass:object_getClass(self))
        if let imageType = json["imageType"] as? String {
            switch imageType {
            case "linkedin":
                mainImageView.image = UIImage(named: "LinkedInLogo", inBundle: bun, compatibleWithTraitCollection: nil)
                mainImageView.hidden = false
                labelLeftEdge.constant = SampleTableViewCell.leftMaxEdge
            default:
                mainImageView.image = nil
                mainImageView.hidden = true
                labelLeftEdge.constant = 0
            }
        } else {
            mainImageView.image = nil
            mainImageView.hidden = true
            labelLeftEdge.constant = 0
        }

        if let buttonText = json["buttonText"] as? String {
            rightButton.hidden = false
            rightButton.setTitle(buttonText, forState: .Normal)
            rightButton.accessibilityLabel = "Double tap to " + buttonText
            buttonWidth.constant = SampleTableViewCell.buttonWidth
        } else {
            rightButton.hidden = true
            buttonWidth.constant = 0
        }

        rightButton.enabled = json["buttonEnabled"] as? Bool ?? false

        titleLabel.text = json["text"] as? String
    }
}
