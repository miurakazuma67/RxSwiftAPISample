//
//  String+.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/09.
//


import Foundation

extension String {
    // 半角英数かどうかを判定
    // https://qiita.com/tananonaka/items/689bab91ef9f6ea942d6
    func isAlphanumeric() -> Bool {
        self.range(of: "[a-z,A-Z,0-9]", options: .regularExpression) != nil
      }

    func validateEmail() -> Bool {
        self.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .regularExpression) != nil
    }
}
