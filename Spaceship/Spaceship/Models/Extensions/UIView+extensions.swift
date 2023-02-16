
import UIKit
import Foundation

extension UIView {
    
    func rounded(radius: CGFloat = 31) {
        layer.cornerRadius = radius
    }
    
    func bordered(width: CGFloat = 5) {
        layer.borderWidth = width
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
 }
