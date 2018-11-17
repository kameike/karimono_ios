//
//  ReturningViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/18.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

class ReturningViewController: UIViewController {
    static func viewController() -> ReturningViewController {
        guard let vc = UIStoryboard.init(name: "Returning", bundle: nil).instantiateInitialViewController() as? ReturningViewController else {
            fatalError("fail to init")
        }

        return vc
    }

    @IBAction func didTap(_ sender: Any) {
        let vc = TextPickerViewController.viewController(describer: TextPickerDescriber.init(
            title: "返すものの名前を入力してください",
            placeHolder: "返すものはなんですか？",
            delegate: self
        ))
        present(vc, animated: true, completion: nil)
    }
}


extension ReturningViewController: TextPickerDelegate {
    func textPcikerViewController(_ viewController: TextPickerViewController, setText text: String) {
        let item = text
        RequestManager.shared.returnItem(Returning(item: item))
    }
}

