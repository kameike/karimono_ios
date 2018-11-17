//
//  BaseTextFeild.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

@IBDesignable
class BaseTextFeild: UITextField {
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
        borderStyle = .none
        textColor = UIColor.Karimono.textPrimary
        font = UIFont.systemFont(ofSize: 24, weight: .bold)
        tintColor = UIColor.Karimono.main
    }
}
