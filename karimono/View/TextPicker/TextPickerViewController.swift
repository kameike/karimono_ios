//
//  TextPickerViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

protocol TextPickerDelegate: class {
    func textPcikerViewController(_ viewController: TextPickerViewController, setText text: String)
}

struct TextPickerDescriber {
    let title: String
    let placeHolder: String
    let delegate: TextPickerDelegate
}

class TextPickerViewController: UIViewController {
    static func viewController(describer: TextPickerDescriber) -> TextPickerViewController {
        guard let vc = UIStoryboard.init(name: "TextPicker", bundle: nil).instantiateInitialViewController() as? TextPickerViewController else {
            fatalError("fail to init")
        }

        vc.delegate = describer.delegate
        vc.titleLabelText = describer.title
        vc.placeHolder = describer.placeHolder

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleLabelText
        textFeild.placeholder = placeHolder
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFeild.becomeFirstResponder()
    }

    private var titleLabelText: String!
    private var placeHolder: String!
    private weak var delegate: TextPickerDelegate?

    @IBOutlet weak var textFeild: BaseTextFeild!
    @IBOutlet weak var titleLabel: SmallBoldLabel!

    @IBAction func didEndEditing(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            return
        }

        delegate?.textPcikerViewController(self, setText: text)
        dismiss(animated: true, completion: nil)
    }
}
