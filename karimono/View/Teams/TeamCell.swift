//
//  TeamCell.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/05.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell, CellDequeuealbe {

    @IBOutlet weak var teamNameLabel: UILabel!

    func fill(with data: Team) {
        teamNameLabel.text = data.name
    }
}
