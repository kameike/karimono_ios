//
//  TeamBorrwings.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamBorrowingsViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = TeamBorrowingViewModel
    var viewModel: TeamBorrowingViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newBorrowingButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()

        tableView.dataSource = self
        BorrowingCell.register(to: tableView)

        viewModel.items
            .bind(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
        .disposed(by: bag)

        newBorrowingButton.rx.tap.asObservable()
            .bind(onNext: { [weak self] _ in self?.createNewBorrowing() })
            .disposed(by: bag)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }

    func createNewBorrowing() {
        let vm = NewBorrwoingViewModel.init(itemName: "", teamName: viewModel.team.name, memo: "")
        let vc = NewBorrwoingViewController.viewController(viewModel: vm, repository: viewModel.repository)
        present(vc, animated: true, completion: nil)
    }
}


extension TeamBorrowingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BorrowingCell.dequeue(at: indexPath, from: tableView)
        cell.fill(with: viewModel.items.value[indexPath.row])
        return cell
    }
}
