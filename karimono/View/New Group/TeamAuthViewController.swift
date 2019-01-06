//
//  TeamAuthViewControlller.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamAuthViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = TeamAuthViewModel
    var viewModel: TeamAuthViewModel!
    @IBOutlet weak var teamNameTextFeild: UITextField!
    @IBOutlet weak var teamNamePasswordFeild: UITextField!
    @IBOutlet weak var closeButton: BaseButton!
    @IBOutlet weak var submitButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()

        closeButton.rx.tap.asObservable()
            .bind(onNext:{ [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)

        viewModel.canClose
            .bind(onNext:{ [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)

        teamNameTextFeild.rx.text.asObservable()
            .bind(to: viewModel.nameBinder)
            .disposed(by: bag)

        teamNamePasswordFeild.rx.text.asObservable()
            .bind(to: viewModel.passwordBinder)
            .disposed(by: bag)

        submitButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in
                self?.viewModel.submit()
            })
            
            .disposed(by: bag)
    }
}
