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
    
    func detectUser(userId: String ) -> Observable<[User]> {
        
        return Observable.create { (observer) -> Disposable in
            
            Firestore.firestore().collection("Users").whereField("userRef", isEqualTo: Firestore.firestore().collection("Users").document(userId)).addSnapshotListener({ (snapShots, error) in
                
                guard let docs = snapShots?.documents else {
                    observer.onError(error!)
                    return
                }
                
                var users: [User] = []
                
                docs.forEach({ (snap) in
                    let data = snap.data()
                    
                    let _user = User(id: snap.reference.documentID, name: data["name"] as? String ?? "none")
                    
                    users.append(_user)
                    
                })
                
                observer.onNext(users)
                
            })
            
            return Disposables.create()
            
        }
        
    }
    
    func createUser(user: User) -> Observable<Void> {
        
        return Observable.create({ (obserber) -> Disposable in
            
            let doc = Firestore.firestore().collection("Users").document(user.id)
            
            doc.setData([
                "name": user.name,
                "userRef": doc
            ]) { error in
                if error == nil {
                    obserber.onCompleted()
                } else {
                    obserber.onError(error!)
                }
            }
            
            return Disposables.create()
        })
        
    }
    
}
