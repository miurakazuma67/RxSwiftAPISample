//
//  NSObject+.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/22.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
