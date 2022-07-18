//
//  TimerViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/18.
//

import UIKit

final class TimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func makeFromStoryboard() -> TimerViewController {
        UIStoryboard(name: "Timer", bundle: nil).instantiateInitialViewController() as! TimerViewController
    }
}
