//
//  TabbarController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/29.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarColor()
        self.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
       }

    ///tabbarの色変更
    private func setTabBarColor() {
        self.tabBar.tintColor = UIColor.green

        //ios15対応
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
