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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !repo.hasLogin() {
            showWelcomeView()
        } else {
            appendBorrowingViews()
        }
    }

    let repo = DataRepository(executor: RequestExecuter())

    func showWelcomeView() {
        let vc = WelcomeViewController.viewController(viewModel: WelcomeViewModel(), repository: repo)
        present(vc, animated: true, completion: nil)
    }


    func appendBorrowingViews() {
        let tabbar = UITabBarController()

        tabbar.tabBar.barTintColor = UIColor.Karimono.main
        tabbar.tabBar.tintColor = .white
        tabbar.tabBar.unselectedItemTintColor = UIColor.Karimono.unselectedTabBar
        tabbar.tabBar.isTranslucent = false

//        let list = BorrowingItemsViewController.viewController()
//        let borrowing = NewBorrowingViewController.viewController()
//        let returning = ReturningViewController.viewController()
//
//        tabbar.addChild(list)
//        tabbar.addChild(borrowing)
//        tabbar.addChild(returning)

        let teams = TeamsViewController.viewController(viewModel: TeamsViewModel(), repository: repo)
        tabbar.addChild(teams)

        addChild(tabbar)
        view.addSubview(tabbar.view)
        tabbar.didMove(toParent: self)
    }
}
