//
//  BaseViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

final class BaseViewController: UIViewController {

    @IBOutlet private weak var moveToReportListButton: UIButton!

    @IBOutlet private weak var moveToTimerButton: UIButton!

    @IBOutlet private weak var moveToPostButton: UIButton!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    private func setupBinding() {
        // サインイン画面に戻りたくないので非表示にする
        self.navigationItem.hidesBackButton = true
        //画面遷移
        moveToReportListButton.rx.tap
            .asSignal()
            .emit (onNext: { _ in
                Router.shared.showReportList(from: self)
            }).disposed(by: disposeBag)

        moveToPostButton.rx.tap
            .asSignal()
            .emit (onNext: { _ in
                Router.shared.showPost(from: self)
            }).disposed(by: disposeBag)

        moveToTimerButton.rx.tap
            .asSignal()
            .emit(onNext: {_ in
                Router.shared.showTimer(from: self)
            }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            Router.shared.showSignUp(from: self)
        }
    }

    static func makeFromStoryboard() -> BaseViewController {
        UIStoryboard(name: "Base", bundle: nil).instantiateInitialViewController() as! BaseViewController
    }
}
