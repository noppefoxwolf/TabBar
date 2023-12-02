import UIKit

open class TabBarButton: UIButton {
    public init(_ item: UITabBarItem) {
        super.init(frame: .null)
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        setImage(item.image, for: .normal)
        setImage(item.selectedImage, for: .selected)
        tintColor = .label
        isPointerInteractionEnabled = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
