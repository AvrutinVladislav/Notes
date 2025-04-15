import UIKit

enum Colors {
    static let mainBackground = Colors.color(light: .init(hex: .mainBackground), dark: .init(hex: .mainBackground))
    static let cellBorderColor = Colors.color(light: .init(hex: .cellBorderColor), dark: .init(hex: .cellBorderColor))
    static let signIn = Colors.color(light: .init(hex: .signIn), dark: .init(hex: .signIn))
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        
        return .init { traitCollection in
            
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}

extension UIColor {
    
    enum Hex: String {
        case mainBackground = "0377fc"
        case cellBorderColor = "01048a"
        case signIn = "262f3b"
    }
    
    convenience init(hex: Hex) {
        
        var hexString: String = hex.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.remove(at: hexString.startIndex) }
        
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
