//
//  MessageCellTableViewCell.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//

import UIKit

final class ReportListCell: UITableViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var memoLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!

    func configure(report: Report) {
        timeLabel.text = report.time
        memoLabel.text = report.message
        usernameLabel.text = report.username
    }
}
