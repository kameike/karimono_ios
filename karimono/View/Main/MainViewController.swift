//
//  MainViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2018/12/08.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if NameRepository.sheard.hasName {
            appendBorrowingViews()
        }
    }

    func showSetNameView() {
        let describer = TextPickerDescriber.init(title: "名前またはニックネームを入力してください", placeHolder: "名前", delegate: self)
        let vc = TextPickerViewController.viewController(describer: describer)
        present(vc, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !NameRepository.sheard.hasName {
            showSetNameView()
        }
    }

    func appendBorrowingViews() {
        let tabbar = UITabBarController()

        tabbar.tabBar.barTintColor = UIColor.Karimono.main
        tabbar.tabBar.tintColor = .white
        tabbar.tabBar.unselectedItemTintColor = UIColor.Karimono.unselectedTabBar
        tabbar.tabBar.isTranslucent = false

        let list = BorrowingItemsViewController.viewController()
        let borrowing = NewBorrowingViewController.viewController()
        let returning = ReturningViewController.viewController()

        tabbar.addChild(list)
        tabbar.addChild(borrowing)
        tabbar.addChild(returning)

        addChild(tabbar)
        view.addSubview(tabbar.view)
        tabbar.didMove(toParent: self)
    }
}

extension MainViewController: TextPickerDelegate {
    func textPcikerViewController(_ viewController: TextPickerViewController, setText text: String) {
        NameRepository.sheard.setName(text)
        appendBorrowingViews()
    }
}
