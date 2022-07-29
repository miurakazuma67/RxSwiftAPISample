//
//  Router.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//


import Foundation
import UIKit

// 画面遷移の処理をViewControllerから切り離すクラス
// 1. ViewContollerなどでRouterの画面遷移の処理を呼び出す。
// 2. RouterはModelやPresenterを初期化しTransitionerの処理を呼び出し、画面遷移する。
// 3. 結果として画面遷移の処理はPresenterとTransitionerが担うのでviewControllerから画面遷移の処理を切り出せる
final class Router {

    static let shared = Router()
    private init() {}

    func showBase(from: UIViewController) {
        let vc = BaseViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

//    func showChat(from: UIViewController) {
//        let vc = ChatViewController.makeFromStoryboard()
//        show(from: from, to: vc)
//    }

    func showSignUp(from: UIViewController) {
        let vc = SignUpViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

    func showReportList(from: UIViewController) {
        let vc = ReportListViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

    func showTimer(from: UIViewController) {
        let vc = TimerViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

    func showPost(from: UIViewController) {
        let vc = PostViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil) {
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
}
