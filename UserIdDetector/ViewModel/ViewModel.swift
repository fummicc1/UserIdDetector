//
//  ViewModel.swift
//  UserIdDetector
//
//  Created by Fumiya Tanaka on 2019/02/16.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    
    private let model: Model // ここは実際は抽象に依存させる。
    private let disposeBag = DisposeBag()
    
    private let _users = BehaviorSubject<[User]>(value: [])
    var users: [User] {
        do {
            return try _users.value()
        } catch {
            print(error)
        }
        
        return []
    }
    
    var buttonObservable: Observable<Void>!
    var tableViewObservable: Observable<Void>!
    var textFieldObservable: Observable<String?>!
    
    init(model: Model = Model(), textEdited: Observable<String?>, didTapEvent: ControlEvent<Void>) {
        
        self.model = model
        
        self.textFieldObservable = textEdited.map({ (text) -> String in
            if text?.isEmpty ?? true { return "" }
            return text!
        })
        
        self.tableViewObservable = _users.map{ _ in }
        
        self.buttonObservable = didTapEvent.asObservable()
        
    }
    
    func didTapCreateButton() {
        
        model.createUser(user: User(id: IdGenerator.setId(length: 6), name: "user\(users.count+1)")).subscribe(
            { result in
                print("ユーザー登録できました！")
        }).disposed(by: disposeBag)
    }
    
}
