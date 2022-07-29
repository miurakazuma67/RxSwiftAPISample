//
//  TimerViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/19.
//

import Foundation
import RxSwift
import RxCocoa

final class TimerViewModel {
    private var timerState: TimerState?

    let isValidRelay = BehaviorRelay<Bool>(value: false)
    let secondsRelay = BehaviorRelay<Int>(value: 0)

    init(input: (
        time: Driver<String>,
        startTaps: Signal<()>,
        stopTaps: Signal<()>
    )) {
        let start = input.startTaps
            .asObservable()
    }

}
