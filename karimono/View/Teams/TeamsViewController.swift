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
    @IBOutlet weak var joinTeamButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()

        tableView.dataSource = self
        tableView.delegate = self
        TeamCell.register(to: tableView)

        createTeamButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in  self?.showTeamAuth(type: .create) })
            .disposed(by: bag)

        joinTeamButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in  self?.showTeamAuth(type: .join) })
            .disposed(by: bag)

        viewModel.teams
            .bind(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }

    @IBAction func logout(_ sender: Any) {
        viewModel.repository.deleteLogin()
    }

    func showTeamAuth(type : TeamAuthType) {
        let vm = TeamAuthViewModel(authType: type)
        let vc = TeamAuthViewController.viewController(viewModel: vm, repository: viewModel.repository)
        present(vc, animated: true, completion: nil)
    }
}

extension TeamsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.teams.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = viewModel.teams.value[indexPath.row]

        let cell = TeamCell.dequeue(at: indexPath, from: tableView)
        cell.fill(with: team)
        return cell
    }
}

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = viewModel.teams.value[indexPath.row]
        let vm = TeamBorrowingViewModel(team: team)
        let vc = TeamBorrowingsViewController.viewController(viewModel: vm, repository: viewModel.repository)

        navigationController?.pushViewController(vc, animated: true)
    }
}
