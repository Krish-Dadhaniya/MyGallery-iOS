import UIKit


enum ManropeFont: String {
    case regular = "Manrope-Regular"
    case medium = "Manrope-Medium"
    case semiBold = "Manrope-SemiBold"
    case bold = "Manrope-Bold"
}

extension UIFont {
    static func customFont(_ size: CGFloat, _ type: ManropeFont) -> UIFont {
        let ratio = UIScreen.main.bounds.size.width / 375
        return UIFont(name: type.rawValue, size: size * ratio)!
    }
}
