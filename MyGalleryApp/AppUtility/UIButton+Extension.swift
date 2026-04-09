import UIKit

extension UIButton {
    
    func applyStyling(
        title: String,
        font: UIFont,
        titleColor: UIColor,
        bgColor: UIColor,
        image: UIImage? = nil,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat = 0,
        borderColor: UIColor? = nil
    ) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        
        if let image = image {
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        } else {
            
            self.layer.cornerRadius = self.frame.height / 2
        }
        
        self.layer.borderWidth = borderWidth
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        
        self.clipsToBounds = true
    }
    
        
        func configure(
            title: String,
            image: UIImage? = nil,
            backgroundColor: UIColor,
            titleColor: UIColor,
            font: UIFont = UIFont.customFont(16, .semiBold)
        ) {
            self.applyStyling(
                title: title,
                font: font,
                titleColor: titleColor,
                bgColor: backgroundColor,
                image: image
            )
        }
}
