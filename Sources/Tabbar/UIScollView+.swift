import UIKit

extension UIWindowScene {
    public func scrollToTop(animated: Bool) {
        guard let scrollView = keyWindow?.rootViewController?.scrollView
        else { return }
        // scrollRectToVisibleだとcellのリサイズを加味してくれないのでindexPathで飛ばす
        let indexPath = IndexPath(row: 0, section: 0)
        if let tableView = scrollView as? UITableView, tableView.hasIndexPath(indexPath) {
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        } else if let collectionView = scrollView as? UICollectionView,
            collectionView.hasIndexPath(indexPath)
        {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
        } else {
            // https://stackoverflow.com/a/15619927/1131587
            let isScrolling = scrollView.layer.animation(forKey: "bounds") != nil
            if !isScrolling {
                let toRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                scrollView.scrollRectToVisible(toRect, animated: animated)
            }
        }
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

extension UITableView {
    func hasIndexPath(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return false }
        return true
    }
}

extension UICollectionView {
    func hasIndexPath(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections else { return false }
        guard indexPath.row < numberOfItems(inSection: indexPath.section) else { return false }
        return true
    }
}
