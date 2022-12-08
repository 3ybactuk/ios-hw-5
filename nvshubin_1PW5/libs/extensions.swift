//
//  extensions.swift
//  nvshubin_1PW2
//
//  Created by Nikita on 11.10.2022.
//

import UIKit

extension CALayer {
    func applyShadow(_ radius: CGFloat? = nil) {
//        self.cornerRadius = radius ?? self.frame.width / 2
        self.shadowColor = UIColor.darkGray.cgColor
        self.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.shadowRadius = 4.0
        self.shadowOpacity = 0.4
        self.masksToBounds = false
    }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    var redComponent: (CGFloat) {
        return rgba.red
    }
    
    var greenComponent: (CGFloat) {
        return rgba.green
    }
    
    var blueComponent: (CGFloat) {
        return rgba.blue
    }
    
    var alphaComponent: (CGFloat) {
        return rgba.alpha
    }
}
