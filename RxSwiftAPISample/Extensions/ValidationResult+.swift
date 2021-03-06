//
//  UILabel+.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/09.
//

import Foundation
import RxSwift
import UIKit

extension ValidationResult {
    var textColor: UIColor{
        switch self{
        case .ok:
            return UIColor.systemGreen
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }

    var description: String{
        switch self{
        case .ok(let message):
            return message
        case .empty(let message):
            return message
        case .validating:
            return ""
        case .failed(let message):
            return message
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.text = result.description
            label.textColor = result.textColor
        }
    }
}

