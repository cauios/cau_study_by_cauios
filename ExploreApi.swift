//
//  ExploreApi.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import Foundation
import FirebaseDatabase
class ExploreApi {
    var REF_EXPLORE = Database.database().reference().child("explore")
    
    func observeExplore(withId id: String, completion: @escaping (Post) -> Void) {
        REF_EXPLORE.child(id).observe(.childAdded, with: {snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: {
                (post) in completion(post)
            })
        })
    }
    
    func observeExploreRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        REF_EXPLORE.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: {
                (post) in completion(post)
            })
        })
    }
    
}
