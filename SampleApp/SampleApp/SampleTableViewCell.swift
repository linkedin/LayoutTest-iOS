// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

enum SampleTableViewCellError: Error {
    case invalidNib
}

open class SampleTableViewCell: UITableViewCell {

    private static let leftMaxEdge: CGFloat = 38
    private static let leftMinEdge: CGFloat = 0
    private static let buttonWidth: CGFloat = 80

    private static let nibName = "SampleTableViewCell"

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rightButton: UIButton!

    @IBOutlet private var labelLeftEdge: NSLayoutConstraint!
    @IBOutlet private var buttonWidth: NSLayoutConstraint!

    open class func registerForTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }

    open class func dequeueForTableView(_ tableView: UITableView, indexPath: IndexPath) -> SampleTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: nibName, for: indexPath) as! SampleTableViewCell
    }

    class func loadFromNib() throws -> SampleTableViewCell {
        guard let viewInBundle = Bundle.main.loadNibNamed(
            SampleTableViewCell.nibName,
            owner: nil,
            options: nil),
              let sampleFailingView = viewInBundle.first as? SampleTableViewCell else {
            throw SampleTableViewCellError.invalidNib
        }

        return sampleFailingView
    }

    func setup(_ json: [AnyHashable: Any]) {
        if let imageType = json["imageType"] as? String {
            switch imageType {
            case "linkedin":
                mainImageView.image = UIImage(named: "LinkedInLogo")
                mainImageView.isHidden = false
                labelLeftEdge.constant = SampleTableViewCell.leftMaxEdge
            default:
                mainImageView.image = nil
                mainImageView.isHidden = true
                labelLeftEdge.constant = 0
            }
        } else {
            mainImageView.image = nil
            mainImageView.isHidden = true
            labelLeftEdge.constant = 0
        }

        if let buttonText = json["buttonText"] as? String {
            rightButton.isHidden = false
            rightButton.setTitle(buttonText, for: .normal)
            rightButton.accessibilityLabel = "Double tap to " + buttonText
            buttonWidth.constant = SampleTableViewCell.buttonWidth
        } else {
            rightButton.isHidden = true
            buttonWidth.constant = 0
        }

        rightButton.isEnabled = json["buttonEnabled"] as? Bool ?? false

        titleLabel.text = json["text"] as? String
    }
}
