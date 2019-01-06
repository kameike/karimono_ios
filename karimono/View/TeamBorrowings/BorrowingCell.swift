//
//  BorrowingCell.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/06.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit

class BorrowingCell: UITableViewCell, CellDequeuealbe {
    @IBOutlet weak var borrowingLabel: UILabel!
    @IBOutlet weak var memo: UILabel!

    func fill(with borrowing: Borrowing) {
        borrowingLabel.text = borrowing.itemName
        // memo.text = borrowing.memo
    }
}
