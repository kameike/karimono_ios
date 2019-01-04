//
//  UIColor+Extenstions.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

/// https://qiita.com/Kyomesuke3/items/eae6216b13c651254f64
extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(displayP3Red: r, green: g, blue: b, alpha: 1)
    }

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}

extension UIColor {
    struct Karimono {
        static var textPrimary: UIColor {
            return UIColor(hex: "333333")
        }

        static var slightGray: UIColor {
            return UIColor(hex: "f2f2f2")
        }

        static var main: UIColor {
            return UIColor(hex: "E13B52")
        }

        static var unselectedTabBar: UIColor {
            return UIColor(hex: "E66C7D")
        }
    }
}
