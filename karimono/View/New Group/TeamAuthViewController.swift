//
//  TeamAuthViewControlller.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamAuthViewController: BaseViewController, ViewModelInjectable {
    typealias ViewModel = TeamAuthViewModel
    var viewModel: TeamAuthViewModel!
    @IBOutlet weak var teamNameTextFeild: UITextField!
    @IBOutlet weak var teamNamePasswordFeild: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
