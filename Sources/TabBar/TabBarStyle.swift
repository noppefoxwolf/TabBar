import Foundation
import UIKit

extension UIViewController {
    public var supportsCustomTabBar: Bool {
        if isLiquidGlassStyle {
            return false
        }
        if isModernSegmentedStyle {
            return false
        }
        if isVisionOS {
            return false
        }
        return true
    }
    
    var isModernSegmentedStyle: Bool {
        if #available(iOS 18.0, *) {
            traitCollection.userInterfaceIdiom == .pad
        } else {
            false
        }
    }
}

fileprivate var isVisionOS: Bool {
    if #available(visionOS 1.0, *) {
        true
    } else {
        false
    }
}

fileprivate var isLiquidGlassStyle: Bool {
    #if compiler(>=6.2)
    if #available(iOS 19.0, *) {
        return !isEnabledUIDesignRequiresCompatibility
    }
    #endif
    return false
}

fileprivate var isEnabledUIDesignRequiresCompatibility: Bool {
    let value = Bundle.main.object(
        forInfoDictionaryKey: "UIDesignRequiresCompatibility"
    )
    return value as? Bool ?? false
}
