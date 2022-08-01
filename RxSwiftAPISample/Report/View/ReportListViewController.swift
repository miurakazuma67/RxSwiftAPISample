//
//  MessageViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//
import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

 // 記録一覧を表示するtableView
final class ReportListViewController: UIViewController, UITableViewDelegate, ProgressHudEnable, ErrorDialogEnable {

    @IBOutlet private weak var tableView: UITableView!

    let progressHud = JGProgressHUD(style: .dark)
    private let disposeBag = DisposeBag()
    var viewModel: ReportListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        tableView.registerCustomCell(ReportListCell.self)
    }

    private func setupBinding() {
        viewModel = ReportListViewModel(
            reportListener: ReportDefaultListener()
        )

        // セルにデータを割り当てる
        viewModel.items
            .drive(tableView.rx.items) { tableView, _, element in
                let cell = tableView.dequeueReusableCustomCell(with: ReportListCell.self)
                cell.configure(report: element)
                return cell
            }
            .disposed(by: disposeBag)
    }

    static func makeFromStoryboard() -> ReportListViewController {
        UIStoryboard(name: "ReportList", bundle: nil).instantiateInitialViewController() as! ReportListViewController
    }
}

