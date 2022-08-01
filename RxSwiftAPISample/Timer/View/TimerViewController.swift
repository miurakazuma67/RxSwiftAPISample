//
//  TimerViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/18.
//

import UIKit
import RxSwift
import RxCocoa

final class TimerViewController: UIViewController {

    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!

    private var timerState: TimerState?
    private let userDefaultsUtility = UserDefaultsUtility()
    private let isValidRelay: BehaviorRelay<Bool> = .init(value: false)
    private let secondsRelay: BehaviorRelay<Int> = .init(value: 0)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLifecycleObserver()
        setupButtons()
        setupLabel()
        setupTimer()
        setupTimerState()
    }

    static func makeFromStoryboard() -> TimerViewController {
        UIStoryboard(name: "Timer", bundle: nil).instantiateInitialViewController() as! TimerViewController
    }
}

// MARK: - Setup

extension TimerViewController {

    //ここ全部VMに移動できる
    private func setupLifecycleObserver() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .map { _ in () }
            .subscribe(onNext: { [weak self] in self?.saveTimerState() })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .map { _ in () }
            .subscribe(onNext: { [weak self] in self?.loadTimerState() })
            .disposed(by: disposeBag)
    }

    private func setupButtons() {
        stopButton.rx.tap.map { false }
            .bind(to: isValidRelay)
            .disposed(by: disposeBag)

        startButton.rx.tap.map { true }
            .bind(to: isValidRelay)
            .disposed(by: disposeBag)

        resetButton.rx.tap.map { 0 }
            .bind(to: secondsRelay)
            .disposed(by: disposeBag)
        isValidRelay
            .map { !$0 }
            .bind(to: resetButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func setupLabel() {
        secondsRelay
            .map { String(format: "%02i:%02i:%02i", $0 / 3600, $0 / 60 % 60, $0 % 60) }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupTimer() {
        isValidRelay
            .distinctUntilChanged()
            .flatMapLatest { $0
                ? Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                : Observable.empty() }
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.secondsRelay.accept(strongSelf.secondsRelay.value + 1)
            })
            .disposed(by: disposeBag)
    }

    private func setupTimerState() {
        guard let timerState = self.timerState else { return }
        addTimeWhileBackground(timerState: timerState)
    }

    private func addTimeWhileBackground(timerState: TimerState) {
        // タイマーが動いていた場合はバックグラウンドにいた時間を足す
        if timerState.isValid == true {
            let interval = Int(Date().timeIntervalSince(timerState.enterBackground))
            secondsRelay.accept(timerState.seconds + interval)
        } else {
            secondsRelay.accept(timerState.seconds)
        }
        isValidRelay.accept(timerState.isValid)
        userDefaultsUtility.removeObject(for: .timerState)
    }
}

// MARK: - UserDefaults

extension TimerViewController {

    private func saveTimerState() {
        let isValid = isValidRelay.value
        let seconds = secondsRelay.value

        if isValid == true && seconds > 0 {
            let timerState = TimerState(isValid: isValid, seconds: seconds, enterBackground: Date())
            userDefaultsUtility.setCodableObject(timerState, key: .timerState)
        }
    }

    private func loadTimerState() {
        guard let timerState = UserDefaultsUtility().decodableObject(of: TimerState.self, for: .timerState) else { return }
    addTimeWhileBackground(timerState: timerState)
    }
}
