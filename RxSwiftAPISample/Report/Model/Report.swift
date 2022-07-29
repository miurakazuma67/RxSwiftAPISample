//
//  Message.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/21.
//

import Foundation
import RxSwift
import Firebase

struct Report {
    var userId: String
    var username: String
    var time: String
    var message: String
    var createdAt: Date
    var updatedAt: Date

    func documentDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "username": username,
            "time": time,
            "message": message,
            "createdAt": Date(),
            "updatedAt": Date()
        ]
    }

    static func create(from: QueryDocumentSnapshot) -> Report {
        let data = from.data()
        return Report(userId: data["userId"] as? String ?? "",
                       username: data["username"] as? String ?? "",
                       time: data["time"] as? String ?? "",
                       message: data["message"] as? String ?? "",
                       createdAt: data["createdAt"] as? Date ?? Date(timeIntervalSince1970: 0),
                       updatedAt: data["createdAt"] as? Date ?? Date(timeIntervalSince1970: 0))
    }
}

class ReportValidator {
    func validateReport(_ message: String) -> ValidationResult {
        if message.isEmpty {
            return .empty(message: "")
        }
        // TODO: このメッセージほんとに必要？
        return .ok(message: "Message acceptable")
    }
}
