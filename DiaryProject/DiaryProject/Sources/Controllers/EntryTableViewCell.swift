//
//  EntryTableViewCell.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 22..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit

struct EntryTableViewCellViewModel {
    let entryText: String
    let timeText: String
    let ampmText: String
}

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmlabel: UILabel!
    
    var viewModel: EntryTableViewCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            entryTextLabel.text = vm.entryText
            timeLabel.text = vm.timeText
            ampmlabel.text = vm.ampmText
        }
    }
}
