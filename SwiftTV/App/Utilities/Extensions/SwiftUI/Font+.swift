
import SwiftUI

extension Font {
    /// 8
    static let extraSmall = Font.appFont(size: FontSize.extraSmall.rawValue)
    /// 12
    static let small = Font.appFont(size: FontSize.small.rawValue)
    /// 16
    static let medium = Font.appFont(size: FontSize.medium.rawValue)
    /// 24
    static let large = Font.appFont(size: FontSize.large.rawValue)
    /// 32
    static let extraLarge = Font.appFont(size: FontSize.extraLarge.rawValue)
}

private extension Font {
    static func appFont(size: CGFloat) -> Font {
        .custom("Futura-Medium", size: size)
    }
}

private enum FontSize: CGFloat {
    case small = 12
    case extraSmall = 8
    case medium = 16
    case large = 24
    case extraLarge = 32
}
