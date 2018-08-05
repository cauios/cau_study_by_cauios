//
//  HashTagApi.swift
//  cau_study_ios
//
//  Created by MBP06 on 2018. 7. 27..
//  Copyright © 2018년 신형재. All rights reserved.
//

import Foundation
import FirebaseDatabase
class HashTagApi {
    var REF_HASHTAG = Database.database().reference().child("hashTag")
    
    func fetchPosts(withTag tag: String, completion: @escaping (String) -> Void) {
        REF_HASHTAG.child(tag.lowercased()).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
    
    func queryTags(text: String, completion: @escaping (String) -> Void) {
        REF_HASHTAG.queryOrderedByKey().queryEqual(toValue: text).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            completion(snapshot.key)
        }
    }
}
