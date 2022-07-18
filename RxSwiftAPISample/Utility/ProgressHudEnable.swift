//
//  ProgressHudEnable.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/17.
//

import UIKit
import JGProgressHUD
import RxCocoa
import RxSwift

protocol ProgressHudEnable: UIViewController {
    var progressHud: JGProgressHUD { get }
}

extension Reactive where Base: ProgressHudEnable {
    var showProgressHud: Binder<Bool> {
        return Binder(self.base) { target, value in
            if value {
                target.progressHud.textLabel.text = "Loading"
                target.progressHud.show(in: target.view)
            } else {
                target.progressHud.dismiss()
            }
        }
    }
}
