//
//  MessageListener.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

protocol ReportListener {
    var items: Observable<[Report]> { get }
}

class ReportDefaultListener: NSObject, ReportListener {
    lazy var items = { createListener() }()
    private var listener: ListenerRegistration?

    private func createListener() -> Observable<[Report]> {

        return Observable<[Report]>.create { observer in
            let db = Firestore.firestore()

            // データを取得
            self.listener = db
                .collection("reports")
                .order(by: "createdAt")
            // 変更を監視するメソッド
                .addSnapshotListener { documentSnapshot, error in
                    guard let documentSnapshot = documentSnapshot else {
                        fatalError("documentSnapshot is nil")
                    }
                    if let error = error {
                        observer.onError(error)
                    } else {
                        // errorじゃなかったら、documentSnapshotからReport型の配列を作成する
                        let documents = documentSnapshot.documents.map {
                            Report.create(from: $0)
                        }
                        observer.onNext(documents)
                    }
                }
            return Disposables.create {
                self.listener?.remove()
            }
        }
    }
}
