//
//  MessageViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

final class ReportListViewModel: NSObject {

    let items: Driver<[Report]>

    init(reportListener: ReportListener) {
        items = reportListener.items
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance) // 複数回発生するので1回にまとめる
            .asDriver(onErrorJustReturn: [])
    }
}
