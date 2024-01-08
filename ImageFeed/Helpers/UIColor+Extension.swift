//
//  UIColor+Extension.swift
//  ImageFeed
//
//  Created by Кирилл on 11.11.2023.
//

import UIKit

extension UIColor {
    static var ifBackground: UIColor { UIColor(named: "YP Background") ?? UIColor.darkGray }
    static var ifBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var ifBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ifGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ifRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ifWhiteAlpha50: UIColor { UIColor(named: "YP White (Alpha 50)") ?? UIColor.lightGray }
    static var ifWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
}
