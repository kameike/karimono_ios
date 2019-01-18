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

extension StoryboardInstanciatable where Self: UIViewController {
    static func loadFromStoryBoard() -> Self {
        guard let vc = UIStoryboard.init(name: storyboardName, bundle: nil).instantiateInitialViewController() as? Self else {
            fatalError()
        }
        return vc
    }

    private static var storyboardName: String {
        return String(describing: self)
    }
}

extension ViewControllerCreatable where Self: UIViewController{
    static func createViewController () -> Self {
        return Self()
    }
}

extension ViewControllerProvidable where Self: ViewModelInjectable {
    static func viewController(viewModel: ViewModel, repository: Repositable) -> Self {
        var vc = provideViewContoller()
        vc.viewModel = viewModel
        vc.viewModel.repository = repository
        return vc
    }
}

typealias StoryBoardBasedViewController = StoryboardInstanciatable & ViewControllerProvidable
typealias InitBaseViewController = ViewControllerCreatable & ViewControllerProvidable

extension StoryboardInstanciatable where Self: ViewControllerProvidable {
    static func provideViewContoller() -> Self {
        return loadFromStoryBoard()
    }
}

extension ViewControllerCreatable where Self: ViewControllerProvidable {
    static func provideViewContoller() -> Self {
        return createViewController()
    }
}

protocol ViewControllerProvidable {
    static func provideViewContoller() -> Self
}

protocol StoryboardInstanciatable {
    static func loadFromStoryBoard() -> Self
}

protocol ViewControllerCreatable {
    static func createViewController () -> Self
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
        guard let view = loadFromXib().instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError()
        }
        return view
    }

    static var name: String {
        return String(describing: self)
    }

}
