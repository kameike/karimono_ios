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

protocol NibProvidable {
    static func loadFromXib() -> UINib
    static var name: String { get }
}

protocol CellDequeuealbe: NibProvidable {
    static func register(to: UITableView)
    static func dequeue(at: IndexPath, from: UITableView) -> Self
}

extension CellDequeuealbe where Self: UITableViewCell {
    static func register(to table: UITableView) {
        table.register(loadFromXib(), forCellReuseIdentifier: name)
    }

    static func dequeue(at path: IndexPath, from table: UITableView) -> Self {
        guard let cell = table.dequeueReusableCell(withIdentifier: name, for: path) as? Self else {
            fatalError()
        }
        return cell
    }
}

extension NibProvidable where Self: UIView {
    static func loadFromXib() -> UINib {
        let nib = UINib(nibName: name, bundle: nil)
        return nib
    }

    static func loadFromNib() -> Self {
        let nib = loadFromXib()
        let view = Self()
        nib.instantiate(withOwner: view, options: nil)
        return view
    }

    static var name: String {
        return String(describing: self)
    }

}
