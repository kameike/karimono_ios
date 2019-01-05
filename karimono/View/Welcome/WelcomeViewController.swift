//
//  WelcomeViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = WelcomeViewModel
    var viewModel: WelcomeViewController.ViewModel!

    @IBOutlet weak var createAccountButton: BaseButton!
    @IBOutlet weak var loginButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in
               self?.presentAccountAuth(.signUp)
            })
            .disposed(by: bag)

        loginButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in
                self?.presentAccountAuth(.signIn)
            })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewModel.isNeedKeepShowing {
            dismiss(animated: false, completion: nil)
        }
    }

    func presentAccountAuth(_ type: AccountAuthRequestType) {
        let model = AccountAuthViewModel.init(authorizeType: type)
        let vc = AccountAuthViewController.viewController(viewModel: model, repository: self.viewModel.repository)
        self.show(vc, sender: nil)
    }
}
