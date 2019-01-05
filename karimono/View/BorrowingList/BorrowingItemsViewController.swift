//
//  BollowingViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/17.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

class BorrowingItemsViewController: UIViewController {
    static func viewController() -> BorrowingItemsViewController {
        guard let vc = UIStoryboard.init(name: "BorrowingItems", bundle: nil).instantiateInitialViewController() as? BorrowingItemsViewController else {
            fatalError("fail to init")
        }

        return vc
    }

    @IBOutlet weak var tableView: UITableView!
    private var refleshControl = UIRefreshControl()
    private var borrowingData: [Borrowing] = []
    private let loadingView = LoadingView()
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Karimono.slightGray

        tableView.dataSource = self

        let nib = UINib(nibName: "BorrowingItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BorrowingItemCell")

        tableView.refreshControl = refleshControl
        refleshControl.addTarget(self, action: #selector(reflesh), for: .valueChanged)
    }

    @objc private func reflesh() {
        if isLoading {
            refleshControl.endRefreshing()
            return
        }
        fetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoading {
            return
        }
        showLoading()
        fetch()
    }

    private func fetch() {
        isLoading = true
    }

    private func showLoading() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    private func hideLoading() {
        loadingView.removeFromSuperview()
        refleshControl.endRefreshing()
    }
}

extension BorrowingItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return borrowingData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BorrowingItemCell", for: indexPath) as? BorrowingItemCell else {
            fatalError()
        }

        let borrowing = borrowingData[indexPath.row]
        cell.fill(with: borrowing)

        return cell
    }
}
