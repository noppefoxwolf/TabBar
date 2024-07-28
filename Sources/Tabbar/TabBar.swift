import UIKit

open class TabBar: UITabBar {
    
    let stackView = UIStackView()
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    public init() {
        super.init(frame: .null)
        loadView()
        
        registerForTraitChanges(
            [UITraitHorizontalSizeClass.self],
            handler: { (traitEnvironment: Self, previousTraitCollection) in
                traitEnvironment.layoutItemPositioning()
            }
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        topConstraint.priority = .defaultLow
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            leadingConstraint,
            trailingConstraint,
        ])
    }
    
    weak var tabBarController: UITabBarController? = nil
    
    var _items: [UITabBarItem]? = nil {
        didSet {
            removeAllButtons()
            
            let buttons = (items ?? []).enumerated().map { (index, item) in
                let button = makeTabBarButton(for: item, at: index)
                let identifier = UIAction.Identifier(#function)
                let action = UIAction(
                    identifier: identifier,
                    handler: { [weak self, index] _ in
                        self?.onTriggerButton(at: index)
                    }
                )
                button.removeAction(identifiedBy: identifier, for: .primaryActionTriggered)
                button.addAction(action, for: .primaryActionTriggered)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
                ])
                return button
            }
            addTabBarButtons(buttons)
        }
    }
    
    open override var items: [UITabBarItem]? {
        get { _items }
        set { _items = newValue }
    }
    
    var _itemPositioning: UITabBar.ItemPositioning = .automatic {
        didSet {
            layoutItemPositioning()
        }
    }
    
    func layoutItemPositioning() {
        switch _itemPositioning {
        case .automatic:
            switch traitCollection.horizontalSizeClass {
            case .compact:
                leadingConstraint.isActive = false
                trailingConstraint.isActive = false
            case .regular, .unspecified:
                leadingConstraint.isActive = true
                trailingConstraint.isActive = true
            @unknown default:
                break
            }
        case .fill:
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
        case .centered:
            leadingConstraint.isActive = false
            trailingConstraint.isActive = false
        @unknown default:
            break
        }
        setNeedsLayout()
    }
    
    open override var itemPositioning: UITabBar.ItemPositioning {
        get { _itemPositioning }
        set { _itemPositioning = newValue }
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
//        super.setItems(items, animated: animated)
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
        TabBarButton(item)
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // adjust height
        let prefferedHeight = bounds.height - safeAreaInsets.bottom
        NSLayoutConstraint.activate(buttons.map { button in
            button.heightAnchor.constraint(equalToConstant: prefferedHeight)
        })
    }
}

