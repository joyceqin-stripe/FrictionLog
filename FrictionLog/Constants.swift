//
//  Constants.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import UIKit
import Foundation

struct Constants {
    static let productImageHeight = CGFloat(128)
    static let padding = CGFloat(16)
    static let cornerRadius = CGFloat(24)
    static let background = UIColor(hexString: "#121212")
    static let secondaryBackground = UIColor.white.withAlphaComponent(0.1)
    static let focusColor = UIColor.white
    static let blurColor = UIColor.lightGray
    static let textColor = UIColor.lightText
    static let accentColor = UIColor.systemOrange
}

extension UIColor {
    convenience init?(hex: Int, alpha: CGFloat = 1.0) {
        let r = (hex >> 16) & 0xFF
        let g = (hex >> 8) & 0xFF
        let b = hex & 0xFF
        
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: alpha)
    }
    
    /// Initializes a UIColor with a hex string (e.g., "#RRGGBB" or "RRGGBB").
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check for # and remove it
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        // Ensure the string is 6 characters long
        guard hex.count == 6, let hexValue = Int(hex, radix: 16) else {
            return nil
        }
        
        self.init(hex: hexValue, alpha: alpha)
    }
}
