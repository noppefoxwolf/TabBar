import UIKit
import Combine

open class TabBarButton: UIButton {
    
    var cancellables: Set<AnyCancellable> = []
    
    public init(_ item: UITabBarItem) {
        super.init(frame: .null)
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        setImage(item.image, for: .normal)
        setImage(item.selectedImage, for: .selected)
        tintColor = .label
        isPointerInteractionEnabled = true
        layer.cornerRadius = 6
        onChangedSelected(isSelected)
        
        NotificationCenter.default
            .publisher(
                for: UIAccessibility.buttonShapesEnabledStatusDidChangeNotification
            )
            .sink { [weak self] _ in
                self?.onChangedButtonShapesEnabled(UIAccessibility.buttonShapesEnabled)
            }
            .store(in: &cancellables)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var isSelected: Bool {
        didSet {
            onChangedSelected(isSelected)
        }
    }
    
    func onChangedSelected(_ isSelected: Bool) {
        configureBackgroundColor(
            isSelected,
            buttonShapesEnabled: UIAccessibility.buttonShapesEnabled
        )
    }
    
    func onChangedButtonShapesEnabled(_ buttonShapesEnabled: Bool) {
        configureBackgroundColor(
            isSelected,
            buttonShapesEnabled: buttonShapesEnabled
        )
    }
    
    func configureBackgroundColor(_ isSelected: Bool, buttonShapesEnabled: Bool) {
        let needsDisplayBackgroundColor = isSelected && buttonShapesEnabled
        backgroundColor = needsDisplayBackgroundColor ? UIColor.tintColor.withAlphaComponent(0.3) : .clear
    }
}
