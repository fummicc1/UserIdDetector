//
//  SampleForUserIdViewController.swift
//  emD_Swift
//
//  Created by Fumiya Tanaka on 2019/02/16.
//  Copyright © 2019 Motohiro Tajima. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var createUserButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private lazy var viewModel = ViewModel(textEdited: textField.rx.text.asObservable(),
                                           didTapEvent: createUserButton.rx.tap)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tableViewObservable.bind(to: reloadData).disposed(by: disposeBag)
        
        viewModel.textFieldObservable.bind(to: textField.rx.text).disposed(by: disposeBag)
        
//        viewModel.buttonObservable.bind(to: createUserButton.rx.tap.asObservable())
        
        createUserButton.rx.tap.subscribe { _ in
            self.viewModel.didTapCreateButton()
        }.disposed(by: disposeBag)
        
    }
}


extension ViewController {
    
    private var reloadData: Binder<Void> {
        return Binder(self) { _me, _void in
            _me.tableView.reloadData()
        }
    }
    
    
    
}
