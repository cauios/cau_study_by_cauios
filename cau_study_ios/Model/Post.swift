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
    // [Dahye Comment] set the class's properties and allocate their types
    var uid: String?
    var id: String?
    var title: String?
    var category: String?
    var tags: String?
    var numOfVacan: String?
    var time: String?
    var location: String?
    var description: String?
    var saved: Bool?// e.g. type이 optional String으로 설정되어 있음!
    var timestamp: Int?
    var wanted: Bool?
}



extension Post{
    static func transformPost(dicr: [String: Any], key: String) -> Post {
        // [Dahye comment] Then, set it to the corresponding value in input data when creating the post instance
        let post = Post()
        
        post.uid = dicr["uid"] as? String
        post.id = key
        post.title = dicr["title"] as? String
        post.category = dicr["category"] as? String
        post.tags = dicr["tags"] as? String
        post.numOfVacan = dicr["numOfVacan"] as? String
        post.time = dicr["time"] as? String
        post.location = dicr["location"] as? String
        post.description = dicr["description"] as? String
        post.saved = dicr["saved"] as? Bool
        post.timestamp = dicr["timestamp"] as? Int
        post.wanted = dicr["wanted"] as? Bool// [0726] Dahye
        return post
    }
}
