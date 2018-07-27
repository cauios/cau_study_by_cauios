//
//  PostApi.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

// [Dahye's comment] This class will only care about post


import Foundation
import FirebaseDatabase
class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    // [Dahye's comment] This method will listen to events at the locations of all posts on the DB
    // in the closure, we'll recieve data snapshot which contains post data.
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dicr: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
// [Dahye's comment] This method uses the input 'post id' to look up the location of all posts for the child nodes corresponding that post id.
    // [Dahye 0723]
    func observePost(withId id: String, completion: @escaping (Post) -> Void){
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dicr: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    
    func observeMyPosts(withId id: String, completion: @escaping (Post)-> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: .value, with: {snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dicr: dict, key: snapshot.key)
                completion(post)
            }
        })
        
    }
    
    func observeSaved(withId id: String, completion: @escaping (Post)-> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: .value, with: {snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dicr: dict, key: snapshot.key)
                completion(post)
            }
        })
        
    }
    
    
    
    
}
