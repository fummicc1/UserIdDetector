//
//  Model.swift
//  UserIdDetector
//
//  Created by Fumiya Tanaka on 2019/02/16.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class Model {
    
//    func validate(id: String?, name: String?) -> Observable<Void> {
//
//        guard let id = id, let name = name else {
//            return Observable.just(())
//        }
//
//        return createUser(user: User(id: id, name: name))
//
//    }
    
    func detectUser(user: User) -> Observable<[String: Any]> {
        
        return Observable.create { (observer) -> Disposable in
            
            Firestore.firestore().collection("Users").addSnapshotListener { (snapShots, error) in                
            }
            
            return Disposables.create()
            
        }
        
    }
    
    func createUser(user: User) -> Observable<Void> {
        
        return Observable.create({ (obserber) -> Disposable in
            
            Firestore.firestore().collection("Users").document(user.id).setData([
                "id": user.id,
                "name": user.name
            ]) { error in
                if error == nil {
                    obserber.onNext(())
                    obserber.onCompleted()
                } else {
                    obserber.onError(error!)
                }
            }
            
            return Disposables.create()
        })
        
    }
    
}
