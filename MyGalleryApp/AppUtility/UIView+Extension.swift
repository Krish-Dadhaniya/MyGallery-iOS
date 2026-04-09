import UIKit

extension UIView {

    func applyGradient(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    ) {
        // Remove existing gradient layers if any
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        // Ensure it's inside the corner radius if any
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Helper to update gradient frame when view bounds change (e.g. in viewDidLayoutSubviews)
    func updateGradientFrame() {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.frame = self.bounds }
    }
    
    // apply shadow to UIView -
    func applyShadow(
        color: UIColor = .black,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 6
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
}
