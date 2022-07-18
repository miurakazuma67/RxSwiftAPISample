//
//  ChatViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/15.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }



    static func makeFromStoryboard() -> ChatViewController {
        UIStoryboard(name: "Chat", bundle: nil).instantiateInitialViewController() as! ChatViewController
    }
}
