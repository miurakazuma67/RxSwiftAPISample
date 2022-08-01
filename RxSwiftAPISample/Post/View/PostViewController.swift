//
//  ReportViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import JGProgressHUD

final class PostViewController: UIViewController, ProgressHudEnable, ErrorDialogEnable {

    let progressHud = JGProgressHUD(style: .dark)
    private let datePicker = UIDatePicker()

    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var timeTextField: UITextField!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        createDatePicker()
    }

    private func setupUI() {
        memoTextView.layer.borderColor = UIColor.systemGreen.cgColor
        memoTextView.layer.borderWidth = 1.0
        timeTextField.addBorder(width: 1.0, color: UIColor.systemGreen, position: .bottom)
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

    private func setupBinding() {
        let reportButton = UIBarButtonItem(title: "記録する", style: .plain, target: nil, action: nil)
            reportButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = reportButton

        // ViewModelにイベント送るため、初期化時にタップイベントとテキストイベントを登録しておく
        let viewModel = PostViewModel(
            input:
            (
                time: timeTextField.rx.text.orEmpty.asDriver(),
                message: memoTextView.rx.text.orEmpty.asDriver(),
                sendTaps: reportButton.rx.tap.asSignal()
            ),
            repository: PostRepository()
        )

        // 投稿ボタンの有効条件
        Driver.combineLatest(viewModel.postEnabled, viewModel.posting)
            .drive(onNext: { postEnabled, posting in
                reportButton.isEnabled = postEnabled && !posting
            })
            .disposed(by: disposeBag)

        // postが完了したことがVMから通知されたら、フィールドをクリア
        viewModel.posted
            .filter { !$0.isEmpty }
            .drive(onNext: { [weak self] _  in
                guard let strongSelf = self else { return }
                strongSelf.timeTextField.text = ""
                strongSelf.timeTextField.sendActions(for: .valueChanged)
                strongSelf.memoTextView.text = ""
            })
            .disposed(by: disposeBag)

        viewModel.posting
            .drive( self.rx.showProgressHud)
            .disposed(by: disposeBag)

        // POST失敗時はアラートを表示する
        viewModel.postError
            .drive( self.rx.showErrorAlert )
            .disposed(by: disposeBag)
    }
}

extension PostViewController {
    private func createDatePicker() {
        datePicker.datePickerMode = .countDownTimer
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        timeTextField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(self.doneClicked))
        done.tintColor = UIColor.systemGreen
        toolbar.setItems([spaceItem, done], animated: true)
        timeTextField.inputAccessoryView = toolbar
    }

    @objc func doneClicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateFormatter.dateFormat = "H時間mm分"
        timeTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
