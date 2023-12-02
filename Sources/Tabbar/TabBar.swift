import UIKit

open class TabBar: UITabBar {
    
    let stackView = UIStackView()
    
    public init() {
        super.init(frame: .null)
        loadView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    weak var tabBarController: UITabBarController? = nil
    
    var _items: [UITabBarItem]? = nil {
        didSet {
            removeAllButtons()
            
            let buttons = (items ?? []).enumerated().map { (index, item) in
                makeTabBarButton(for: item, at: index)
            }
            addTabBarButtons(buttons)
        }
    }
    
    open override var items: [UITabBarItem]? {
        get { _items }
        set { _items = newValue }
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        _items = items
    }
    
    func onTriggerButton(at index: Int) {
        let alreadySelected = buttons[index].isSelected
        if alreadySelected {
            onTriggerContentPop()
        } else {
            tabBarController?.selectedIndex = index
            updateButtonSelections()
        }
    }
    
    func onTriggerContentPop() {
        let nc = tabBarController?.selectedViewController as? UINavigationController
        if let nc, nc.viewControllers.count > 1 {
            nc.popToRootViewController(animated: true)
        } else {
            window?.windowScene?.scrollToTop(animated: true)
        }
    }
    
    func updateButtonSelections() {
        let selectedIndex = _items?.firstIndex(where: { $0 == _selectedItem })
        for (index, button) in buttons.enumerated() {
            button.isSelected = index == selectedIndex
        }
    }
    
    var _selectedItem: UITabBarItem? = nil {
        didSet {
            updateButtonSelections()
            if let _selectedItem {
                delegate?.tabBar?(self, didSelect: _selectedItem)
            }
        }
    }
    
    open override var selectedItem: UITabBarItem? {
        get { _selectedItem }
        set { _selectedItem = newValue }
    }
    
    open func makeTabBarButton(for item: UITabBarItem, at index: Int) -> TabBarButton {
        let button = TabBarButton(item)
        let action = UIAction(handler: { [weak self, index] _ in
            self?.onTriggerButton(at: index)
        })
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }
    
    func addTabBarButtons(_ buttons: [TabBarButton]) {
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
    }
    
    func removeAllButtons() {
        for button in buttons {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
    }
    
    var buttons: [TabBarButton] {
        stackView.arrangedSubviews.compactMap({ $0 as? TabBarButton })
    }
}

