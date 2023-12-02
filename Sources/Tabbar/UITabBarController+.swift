import UIKit

extension UITabBarController {
    public func setTabbar(_ tabBar: TabBar) {
        setValue(tabBar, forKey: "tabBar")
        tabBar.tabBarController = self
    }
}
