//
//  TeamsTableViewControler.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamsViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = TeamsViewModel
    var viewModel: TeamsViewController.ViewModel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createTeamButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()
        viewModel.fetch()

        createTeamButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in  self?.showTeamAuth(type: .create) })
            .disposed(by: bag)
    }

    func showTeamAuth(type : TeamAuthType) {
        let vm = TeamAuthViewModel(authType: type)
        let vc = TeamAuthViewController.viewController(viewModel: vm, repository: viewModel.repository)
        present(vc, animated: true, completion: nil)
    }
}

