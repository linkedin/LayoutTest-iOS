// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    let data = [
        [
            "imageType":"linkedin",
            "text": "Short piece of text",
            "buttonText": "Share",
            "buttonEnabled": true
        ],
        [
            "imageType":"linkedin",
            "text": "A long, long piece of text which spans multiple lines. This is an example of what happens when the text gets long.",
            "buttonText": "Share",
            "buttonEnabled": true
        ],
        [
            "text": "Another short piece of text",
            "buttonText": "Share",
            "buttonEnabled": true
        ]
    ]

    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100

        SampleTableViewCell.registerForTableView(tableView)
    }

    // MARK: TableView

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SampleTableViewCell.dequeueForTableView(tableView, indexPath: indexPath)
        cell.setup(data[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
