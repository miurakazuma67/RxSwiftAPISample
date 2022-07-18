//
//  BaseViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/18.
//

import UIKit
import RxSwift
import RxCocoa

final class BaseViewController: UIViewController {

    @IBOutlet private weak var moveToChatButton: UIButton!
    @IBOutlet private weak var moveToTimerButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    private func setupBinding() {
        //画面遷移
        moveToChatButton.rx.tap
            .asSignal()
            .emit (onNext: { _ in
                Router.shared.showChat(from: self)
            }).disposed(by: disposeBag)

        moveToTimerButton.rx.tap
            .asSignal()
            .emit(onNext: {_ in
                Router.shared.showTimer(from: self)
            }).disposed(by: disposeBag)
    }

    static func makeFromStoryboard() -> BaseViewController {
        UIStoryboard(name: "Base", bundle: nil).instantiateInitialViewController() as! BaseViewController
    }
}
