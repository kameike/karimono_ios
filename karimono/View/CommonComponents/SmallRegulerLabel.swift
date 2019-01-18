//
//  SmallLabel.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

@IBDesignable
class SmallLabel: BaseLabel {
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

    override func commonInit() {
        super.commonInit()
        font = .systemFont(ofSize: 14, weight: .regular)
        textColor = .gray
    }
}
