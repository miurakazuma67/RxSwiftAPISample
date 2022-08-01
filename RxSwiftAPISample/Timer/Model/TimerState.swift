//
//  TimerState.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/19.
//

import Foundation

/// タイマーの状態を管理
struct TimerState: Codable {
    let isValid: Bool // タイマーが開始されているか、停止されているか
    let seconds: Int // バックグラウンドに入った時点のタイマーの秒数
    let enterBackground: Date // バックグラウンドに入った時間
}
