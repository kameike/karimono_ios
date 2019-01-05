//
//  NewBorrowing.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/17.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

class NewBorrowingViewController: UIViewController {
    static func viewController() -> NewBorrowingViewController {
        guard let vc = UIStoryboard.init(name: "NewBorrowing", bundle: nil).instantiateInitialViewController() as? NewBorrowingViewController else {
            fatalError("fail to init")
        }

        return vc
    }

    @IBAction func sendDidTapped(_ sender: Any) {
        let vc = TextPickerViewController.viewController(describer: TextPickerDescriber.init(
            title: "借りるものの名前を入力してください",
            placeHolder: "何を借りますか？",
            delegate: self
        ))

        present(vc, animated: true, completion: nil)
    }
}

extension NewBorrowingViewController: TextPickerDelegate {
    func textPcikerViewController(_ viewController: TextPickerViewController, setText text: String) {
        // let name = NameRepository.sheard.name



    }
}
