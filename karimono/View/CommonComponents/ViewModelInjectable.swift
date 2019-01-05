//
//  ViewModelInjectable.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/04.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit
import RxCocoa

protocol RepositoryInjectable {
    var repository: Repositable! { get set }
}

protocol RequestStateHoldable {
    var requestNeedShowLoading: BehaviorRelay<Bool> { get }
    var errorNeedShowModal: BehaviorRelay<KarimonoRequestError?> { get }
}

protocol ViewModelInjectable {
    associatedtype ViewModel: RepositoryInjectable & RequestStateHoldable
    var viewModel: ViewModel! { get set }
}

extension ViewModelInjectable where Self: UIViewController {
    static func viewController(viewModel: ViewModel, repository: Repositable) -> UIViewController {
        var vc = loadFromStoryBoard()
        vc.viewModel = viewModel
        vc.viewModel.repository = repository
        return vc
    }

    private static func loadFromStoryBoard() -> Self {
        guard let vc = UIStoryboard.init(name: storyboardName, bundle: nil).instantiateInitialViewController() as? Self else {
            fatalError()
        }
        return vc
    }

    private static var storyboardName: String {
        return String(describing: self)
    }
}

