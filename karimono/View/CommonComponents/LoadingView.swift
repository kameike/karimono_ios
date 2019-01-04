//
//  Loading.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/09.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingView: UIView {
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

    private let margin: CGFloat = 18

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        let loading = UIActivityIndicatorView(style: .whiteLarge)
        let view = UIView()

        loading.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.6
        view.layer.cornerRadius = 18

        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            loading.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            loading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            loading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
            ])

        addSubview(view)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

        loading.startAnimating()
    }
}
