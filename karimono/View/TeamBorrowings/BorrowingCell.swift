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
    @IBOutlet weak var name: SmallLabel!
    @IBOutlet weak var date: SmallLabel!

    func fill(with borrowing: Borrowing) {
        borrowingLabel.text = borrowing.itemName
        if borrowing.memo == "" {
            memo.isHidden = true
        } else {
            memo.text = borrowing.memo
            memo.isHidden = false
        }

        name.text = borrowing.account.name

        let d = Date()

        date.text = DateFormatter.localizedString(from: d, dateStyle: .short, timeStyle: .short)
    }
}
