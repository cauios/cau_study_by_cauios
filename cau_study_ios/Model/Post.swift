//
//  Post.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//
// [Dahye Comment]Data related tasks will be done in Model group!!
// Post.swift deals with a class whose instances hold the data od a post we retreive from the database.

import Foundation
class Post {
    var id: String?
    var title: String?
    var category: String?
    var tags: String?
    var eligibility: String?
    var duration: String?
    var location: String?
    var numOfVacan: String?
    var contact: String?
    var description: String?
    
}

extension Post{
    static func transformPost(dicr: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.title = dicr["title"] as? String
        post.category = dicr["category"] as? String
        post.tags = dicr["tags"] as? String
        post.eligibility = dicr["eligibility"] as? String
        post.duration = dicr["duration"] as? String
        post.location = dicr["location"] as? String
        post.numOfVacan = dicr["numOfVacan"] as? String
        post.contact = dicr["contact"] as? String
        post.description = dicr["description"] as? String
        
        return post
    }
}
