import UIKit

extension UIWindowScene {
    public func scrollToTop(animated: Bool) {
        guard let scrollView = keyWindow?.rootViewController?.scrollView else { return }
        guard scrollView.scrollsToTop else { return }
        let toRect = CGRect(
            origin: .zero,
            size: CGSize(width: Double.leastNonzeroMagnitude, height: Double.leastNonzeroMagnitude)
        )
        scrollView.scrollRectToVisible(toRect, animated: true)
    }
}

extension UIViewController {
    var scrollView: UIScrollView? {
        contentScrollView(for: .top) ?? UIViewController.scrollView(of: view)
    }
    
    private static func scrollView(of view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            scrollView
        } else {
            view.subviews.lazy.compactMap({ UIViewController.scrollView(of: $0) }).first
        }
    }
}
