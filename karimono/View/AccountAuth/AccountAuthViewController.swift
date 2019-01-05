//
//  PassAndIdGetterViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AccountAuthViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = AccountAuthViewModel
    var viewModel: AccountAuthViewModel!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authRequestButton: BaseButton!
    @IBOutlet weak var closeViewControllerButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()

        nameTextField.rx.text.asObservable()
            .bind(to: viewModel.nameBinder)
            .disposed(by: bag)

        passwordTextField.rx.text.asObservable()
            .bind(to: viewModel.passBinder)
            .disposed(by: bag)

        authRequestButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.executeAuth()
            })
            .disposed(by: bag)

        viewModel.canSubmitBehavior
            .bind(to: authRequestButton.rx.isEnabled)
            .disposed(by: bag)

        viewModel.canClosePublish
            .bind(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)

        closeViewControllerButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
    }
}
