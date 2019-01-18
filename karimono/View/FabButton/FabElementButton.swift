//
//  FabButton.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/13.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class FabElementButton: UIView, NibProvidable {
    @IBOutlet weak var labelContainer: BaseLabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!

    func setup(label text: String, icon: UIImage) {
        labelContainer.backgroundColor = .white
        labelContainer.shadowColor = UIColor.white
        labelContainer.shadowOffset = CGSize(width: 0, height: 0)
        labelContainer.layer.shadowRadius = 10

        image.image = icon
        image.layer.cornerRadius = image.frame.height / 2

        label.text = text
        label.textColor = UIColor.Karimono.textPrimary
    }

    func show(withAnimation useAnimation: Bool) {
    }

    func hide(withAnimation useAnimation: Bool) {
    }
}
