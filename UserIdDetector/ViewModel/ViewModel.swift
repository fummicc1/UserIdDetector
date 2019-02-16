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
    
    private let _users = BehaviorRelay<[User]>(value: [])
    var users: [User] {
        return _users.value
    }
    
    var buttonObservable: Observable<Void>!
    var tableViewObservable: Observable<Void>!
    var textFieldObservable: Observable<String?>!
    var didTextChanged: Observable<Void>!
    
    init(model: Model = Model(), textEdited: Observable<String?>, didTapEvent: ControlEvent<Void>, didTextChanged: Observable<Void>) {
        
        self.model = model
        
        self.didTextChanged = didTextChanged
        
        self.textFieldObservable = textEdited.map({ (text) -> String in
            if text?.isEmpty ?? true { return "" }
            return text!
        })
        
        self.tableViewObservable = _users.map{ _ in }
        
        self.buttonObservable = didTapEvent.asObservable()
        
        let response = self.didTextChanged.withLatestFrom(textFieldObservable).flatMap { [weak self] (value) -> Observable<Event<[User]>> in
            guard let me = self, let text = value else {
                return Observable.empty()
            }
            
            return me.model.detectUser(userId: text).materialize()
            
        }.share()
        
        
        response.flatMap { (event) -> Observable<[User]> in
            event.element.map(Observable.just) ?? Observable.empty()
        }.bind(to: _users).disposed(by: disposeBag)
        
        response.flatMap { (event) -> Observable<Error> in
            event.error.map(Observable.just) ?? .empty()
            }.subscribe(onNext: { error in
                print(error)
            }).disposed(by: disposeBag)
        
    }
    
    func didTapCreateButton() {
        
        model.createUser(user: User(id: IdGenerator.setId(length: 6), name: "サンプル")).subscribe(
            { result in
                print("ユーザー登録できました！")
        }).disposed(by: disposeBag)
    }
}
