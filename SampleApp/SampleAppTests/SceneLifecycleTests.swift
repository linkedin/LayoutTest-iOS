import UIKit
import XCTest
@testable import SampleApp

final class SceneLifecycleTests: XCTestCase {
    func testRootWindow() {
        let applicationDelegate = UIApplication.shared.delegate as? AppDelegate
        let window: UIWindow?

        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
            window = (scene?.delegate as? SceneDelegate)?.window
            XCTAssertNotNil(scene)
            XCTAssertTrue(window?.windowScene === scene)
            XCTAssertNil(applicationDelegate?.window)
        } else {
            window = applicationDelegate?.window
        }

        XCTAssertNotNil(window)
        let navigationController = window?.rootViewController as? UINavigationController
        XCTAssertTrue(navigationController?.viewControllers.first is HomeViewController)
    }
}
