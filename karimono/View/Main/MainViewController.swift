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

    @IBOutlet weak var fabContainer: UIView!
    let repo = DataRepository(executor: RequestExecuter())


    func showWelcomeView() {
        let vc = WelcomeViewController.viewController(viewModel: WelcomeViewModel(), repository: repo)
        present(vc, animated: true, completion: nil)
    }

    var prepared = false

    func appendBorrowingViews() {
        if prepared {
            return
        }
        prepared = true

        let teams = TeamsViewController.viewController(viewModel: TeamsViewModel(), repository: repo)
        let nav = UINavigationController(rootViewController: teams)

        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.tintColor = .black


        addChild(nav)

        guard let cv = nav.view else {
            return
        }
        view.insertSubview(cv, at: 0)

        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])

        nav.didMove(toParent: self)


        let fab = FabButtonUIViewController.viewController(viewModel: FabButtonViewModel(), repository: repo)
        addChild(fab)
        fab.view.translatesAutoresizingMaskIntoConstraints = false
        fabContainer.addSubview(fab.view)
        NSLayoutConstraint.activate([
            fab.view.bottomAnchor.constraint(equalTo: fabContainer.bottomAnchor),
            fab.view.topAnchor.constraint(equalTo: fabContainer.topAnchor),
            fab.view.leadingAnchor.constraint(equalTo: fabContainer.leadingAnchor),
            fab.view.trailingAnchor.constraint(equalTo: fabContainer.trailingAnchor),
            ])

        fab.didMove(toParent: self)
    }
}
