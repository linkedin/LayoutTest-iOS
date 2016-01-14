// © 2015 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutTestBase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootViewController = LYTCatalogTableViewController()
        rootViewController.ViewProviderClass = SampleTableViewCell.self
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()

        return true
    }
}

extension SampleTableViewCell: LYTViewCatalogProvider {
    public class func dataSpecForTest() -> [NSObject: AnyObject] {
        return [
            "text": LYTStringValues(),
            "buttonText": LYTDataValues(values: ["Share", "Like", NSNull()]),
            "buttonEnabled": LYTBoolValues(),
            "imageType": LYTDataValues(values: ["linkedin", NSNull()])
        ]
    }

    public class func viewForData(data: [NSObject: AnyObject], reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> UIView {
        let view = reuseView as? SampleTableViewCell ?? NSBundle.mainBundle().loadNibNamed("SampleTableViewCell", owner: nil, options: nil)[0] as! SampleTableViewCell
        view.setup(data)
        return view
    }

    public static func registerClassOnTableView(tableView: UITableView) {
        SampleTableViewCell.registerForTableView(tableView)
        tableView.estimatedRowHeight = 100
    }

    public static func heightForTableViewCellForCatalogFromData(data: [NSObject : AnyObject]) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public static func reuseIdentifier() -> String {
        return "SampleTableViewCell"
    }
}

