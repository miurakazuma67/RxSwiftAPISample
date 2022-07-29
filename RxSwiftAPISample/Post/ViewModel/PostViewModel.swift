//
//  InputToolBarViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class PostViewModel: NSObject {
    let postValidation: Driver<ValidationResult> // メモを投稿できるかどうかのバリデーション
    let postEnabled: Driver<Bool> // 投稿できるかどうかをViewに通知
    let posting: Driver<Bool> // 投稿中をViewに通知
    let posted: Driver<String> // 投稿が完了したのをViewに通知
    let postError: Driver<Error> // 投稿失敗時のエラーをViewに通知

    init(input:(
        time: Driver<String>,
        message: Driver<String>,
        sendTaps: Signal<()>
        ),
         repository: PostRepositoryProtocol
        ) {

        let messageValidator = ReportValidator()
        postValidation = input.message
            .map { message in
                messageValidator.validateReport(message)
            }

        let posting = ActivityIndicator()
        self.posting = posting.asDriver()

        let timeAndMessage = Driver.combineLatest(input.time, input.message) { (time: $0, message: $1) }

        // ボタンタップを検知してFirestoreに保存する
        let results = input.sendTaps
            .asObservable()
            .withLatestFrom(timeAndMessage)
            .flatMapLatest { tuple in
                repository.post(time: tuple.time, message: tuple.message)
                    .trackActivity(posting)
                    .materialize()
            }
            .share(replay: 1)

        posted = results
            .filter { $0.event.element?.documentID != nil }
            .map { $0.event.element?.documentID ?? "" }
            .asDriver(onErrorJustReturn: "" )

        postError = results
            .compactMap { $0.event.error }
            .asDriver(onErrorJustReturn: MyError.unknown )

        postEnabled = Driver.combineLatest(postValidation, posting) { message, isPosting in
            message.isValid && !isPosting
        }
            .distinctUntilChanged()
    }
}
