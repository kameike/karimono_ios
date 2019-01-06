//
//  BorrowingItemsCell.swift
//  karimono
//
//  Created by Kei Kameda on 2018/11/17.
//  Copyright © 2018 Kei Kameda. All rights reserved.
//

import UIKit

class BorrowingItemCell: UITableViewCell {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var borrowerName: UILabel!
    @IBOutlet weak var background: DropShadowBackgournd!

    func fill(with borrowing: Borrowing) {

        
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.background.backgroundColor = UIColor.Karimono.slightGray
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.background.backgroundColor = .white
            }, completion: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.background.backgroundColor = UIColor.Karimono.slightGray
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.background.backgroundColor = .white
            }, completion: nil)
        }
    }
}
