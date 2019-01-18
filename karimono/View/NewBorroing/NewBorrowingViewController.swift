//
//  NewBorrowingViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit
import RxSwift

class NewBorrwoingViewController: BaseViewController, StoryBoardBasedViewController, ViewModelInjectable {
    typealias ViewModel = NewBorrwoingViewModel
    var viewModel: NewBorrwoingViewController.ViewModel!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var memo: UITextView!
    @IBOutlet weak var submitButton: BaseButton!
    @IBOutlet weak var closeButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        teamName.text = viewModel.teamNameBinder.value
        teamName.rx.text.asObservable()
            .flatMap { Observable.from(optional: $0) }
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.teamNameBinder)
            .disposed(by: bag)


        itemName.text = viewModel.itemNameBinder.value
        itemName.rx.text.asObservable()
            .flatMap { Observable.from(optional: $0) }
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.itemNameBinder)
            .disposed(by: bag)

        memo.text = viewModel.memoBinder.value
        memo.rx.text.asObservable()
            .flatMap { Observable.from(optional: $0) }
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.memoBinder)
            .disposed(by: bag)

        submitButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in
                self?.viewModel.submit()
            })
            .disposed(by: bag)

        closeButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)

        viewModel.borrowComplete
            .bind(onNext: {[weak self] res in self?.showBorrowCompleteAndDismiss(borrowing: res) })
            .disposed(by: bag)
    }


    func showBorrowCompleteAndDismiss(borrowing: Borrowing) {
        let vc = UIAlertController(title: "かりました", message: "\(borrowing.itemName)を借りました", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil) })
        vc.addAction(action)

        present(vc, animated: true, completion: nil)
    }
}
