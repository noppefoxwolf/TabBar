import UIKit

extension UITabBarController {
    public func setTabBar(_ tabBar: TabBar) {
        setValue(tabBar, forKey: "tabBar")
        tabBar.tabBarController = self
    }
}
