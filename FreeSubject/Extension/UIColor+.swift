//
//  UIColor+.swift
//  FreeSubject
//
//  Created by qualson1 on 2022/09/03.
//

import UIKit

enum CustomColor {
    case brandColor
    case defaultBackgroundColor
    case defaultGrayColor
    case UISwitchColor
}

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, a: Int = 1) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    static func customColor(_ color: CustomColor) -> UIColor {
        switch color {
        case .brandColor:
            return UIColor(red: 0.105, green: 0.294, blue: 0.4, alpha: 1)
        case .defaultBackgroundColor:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        case .defaultGrayColor:
            return UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        case .UISwitchColor:
            return UIColor(red: 0.08, green: 0.5, blue: 0.25, alpha: 1)
        }
    }
}
