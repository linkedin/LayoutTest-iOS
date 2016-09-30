// © 2016 LinkedIn Corp. All rights reserved.
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = LYTCatalogTableViewController()
        rootViewController.viewProviderClass = SampleTableViewCell.self
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()

        return true
    }
}

extension SampleTableViewCell: LYTViewCatalogProvider {
    public class func dataSpecForTest() -> [AnyHashable: Any] {
        return [
            "text": LYTStringValues(),
            "buttonText": LYTDataValues(values: ["Share", "Like", nil]),
            "buttonEnabled": LYTBoolValues(),
            "imageType": LYTDataValues(values: ["linkedin", nil])
        ]
    }

    public class func view(forData data: [AnyHashable: Any], reuse reuseView: UIView?, size: LYTViewSize?, context: AutoreleasingUnsafeMutablePointer<AnyObject?>?) -> UIView {
        let view = reuseView as? SampleTableViewCell ?? Bundle.main.loadNibNamed("SampleTableViewCell", owner: nil, options: nil)?[0] as! SampleTableViewCell
        view.setup(data)
        return view
    }

    public static func registerClass(on tableView: UITableView) {
        SampleTableViewCell.registerForTableView(tableView)
        tableView.estimatedRowHeight = 100
    }

    public static func heightForTableViewCellForCatalog(fromData data: [AnyHashable: Any]) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public static func reuseIdentifier() -> String {
        return "SampleTableViewCell"
    }
}

