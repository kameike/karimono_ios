//
//  DropShadowBackgournd.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

@IBDesignable
class DropShadowBackgournd: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
    }

    func commonInit() {
        layer.shadowOffset = CGSize(width: 0, height: 0 )
        layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.cornerRadius = 24
        clipsToBounds = false
    }
}
