import SwiftUI
import TabBar

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ViewController()
                .ignoresSafeArea()
        }
    }
}

struct ViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        UITabBarController()
    }
    
    func updateUIViewController(
        _ uiViewController: UITabBarController,
        context: Context
    ) {
        let vcs = (0..<1).map { index in
            let vc = UIHostingController(rootView: List {
                ForEach(0..<100) { _ in
                    Text("Hello, World!")
                }
            })
            vc.TabBarItem = UITabBarItem(
                title: "\(index) Item",
                image: UIImage(systemName: "house"),
                tag: index
            )
            vc.TabBarItem.selectedImage = UIImage(systemName: "house.fill")
            return vc
        }
        let vcs2 = (0..<1).map { index in
            let vc = UIHostingController(rootView: List {
                ForEach(0..<100) { _ in
                    Text("Hello, TabBar!")
                }
            })
            vc.TabBarItem = UITabBarItem(
                title: "\(index) Item",
                image: UIImage(systemName: "bell"),
                tag: index
            )
            vc.TabBarItem.selectedImage = UIImage(systemName: "bell.fill")
            return vc
        }
        uiViewController.setTabBar(TabBar())
        uiViewController.setViewControllers(vcs + vcs2, animated: false)
    }
}

