//
//  BaseViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let bag: DisposeBag = DisposeBag()
    let loadingView = LoadingView()

    func addLoadingView() {
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }

    func removeLoadingView() {
        loadingView.removeFromSuperview()
    }

    func switchLoading(shouldShow: Bool) {
        if shouldShow {
            addLoadingView()
        } else {
            removeLoadingView()
        }
    }
}

extension ViewModelInjectable where Self: BaseViewController {
    func bindLoadingStatus() {
        viewModel.requestNeedShowLoading
            .bind(onNext: {[weak self] isShouldShow in self?.switchLoading(shouldShow: isShouldShow)})
            .disposed(by: bag)

        viewModel.errorNeedShowModal
            .bind(onNext: { [weak self] err in
                guard let err = err else {
                    return
                }
                let vc = UIAlertController(title: "error", message: err.reason, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                vc.addAction(action)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}
