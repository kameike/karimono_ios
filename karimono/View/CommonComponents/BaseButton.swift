//
//  BaseButton.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

@IBDesignable
class BaseButton: UIButton {
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

    private func commonInit() {
        backgroundColor = UIColor.Karimono.main
        layer.cornerRadius = 8
        tintColor = UIColor.white
    }
}
