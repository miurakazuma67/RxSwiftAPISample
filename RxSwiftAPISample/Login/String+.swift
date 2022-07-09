//
//  String+.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/09.
//


import Foundation

extension String {
    //半角英数かどうかを判定
    func isAlphanumeric() -> Bool {
        self.range(of: "[a-z,A-Z,0-9]", options: .regularExpression) != nil
      }
}
