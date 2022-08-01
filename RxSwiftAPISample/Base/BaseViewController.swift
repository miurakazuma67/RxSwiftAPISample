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
    @IBOutlet private weak var logoutButton: UIButton!

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
                let storyboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "Post") as! PostViewController//遷移先のViewControllerを設定
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
            }).disposed(by: disposeBag)

        moveToTimerButton.rx.tap
            .asSignal()
            .emit(onNext: { _ in
                Router.shared.showTimer(from: self)
            }).disposed(by: disposeBag)

        // ログアウト
        // ダイアログつける
        logoutButton.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] _ in
                let alert: UIAlertController = UIAlertController(title: "注意", message: "ログアウトしますか？", preferredStyle:  UIAlertController.Style.alert)

                let defaultAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{

                    (action: UIAlertAction!) -> Void in
                    do {
                        try Auth.auth().signOut()
                        self?.signUp()
                    } catch let error as NSError{
                        print(error)
                    }
                })

                let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler:{

                    (action: UIAlertAction!) -> Void in
                })

                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            self.signUp()
        }
    }

    // do catch内で使うために切り分け
    private func signUp() {
        Router.shared.showSignUp(from: self)
    }

    static func makeFromStoryboard() -> BaseViewController {
        UIStoryboard(name: "Base", bundle: nil).instantiateInitialViewController() as! BaseViewController
    }
}
