//
//  TeamBorrwings.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamBorrowingsViewController: BaseViewController, StoryBoardBasedViewController, ViewModelInjectable {
    typealias ViewModel = TeamBorrowingViewModel
    var viewModel: TeamBorrowingViewModel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingStatus()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        BorrowingCell.register(to: tableView)

        title = "\(viewModel.team.name)の貸し出し状況"

        viewModel.items
            .bind(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
        .disposed(by: bag)


        viewModel.returnCompleteRelay
            .bind(onNext: { [weak self] b in self?.returnBorrowingComplete(b) })
            .disposed(by: bag)

//        newBorrowingButton.rx.tap.asObservable()
//            .bind(onNext: { [weak self] _ in self?.createNewBorrowing() })
//            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }

    func createNewBorrowing() {
//        let vm = NewBorrwoingViewModel.init(itemName: "", teamName: viewModel.team.name, memo: "")
//        let vc = NewBorrwoingViewController.viewController(viewModel: vm, repository: viewModel.repository)

        let vc = QrCodeReaderViewController()
        present(vc, animated: true, completion: nil)
    }

    func returnBorrowingComplete(_ borrowing: Borrowing) {
        let vc = UIAlertController(title: "完了", message: "\(borrowing.itemName)を \(borrowing.team.name) に返しました", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: { _ in
            self.viewModel.fetch()
        })
        vc.addAction(action)
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

extension TeamBorrowingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let b = viewModel.items.value[indexPath.row]
//        viewModel.returnBorrowing(b)
    }
}
