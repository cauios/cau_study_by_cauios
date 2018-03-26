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
    var title: String?
    var category: String?
    var objectives: String?
    var eligibility: String?
    var duration: String?
    var location: String?
    var numOfVacan: String?
    var contact: String?
    var photoUrl: String?
    var description: String?
    
//    init(titleText: String, categoryText: String, objectivesText: String, eligibilityText: String, durationText: String, locationText: String, numOfVacanText: String, contactText: String, photoUrlString: String, descriptionText: String) {
//        title = titleText
//        category = categoryText
//        objectives = objectivesText
//        eligibility = eligibilityText
//        duration = durationText
//        location = locationText
//        numOfVacan = numOfVacanText
//        contact = contactText
//        photoUrl = photoUrlString
//        description = descriptionText
//    }
}

extension Post{
    static func transformPost(dicr: [String: Any]) -> Post {
        let post = Post()
        
        post.title = dicr["title"] as? String
        post.category = dicr["category"] as? String
        post.objectives = dicr["objectives"] as? String
        post.eligibility = dicr["eligibility"] as? String
        post.duration = dicr["duration"] as? String
        post.location = dicr["location"] as? String
        post.numOfVacan = dicr["numOfVacan"] as? String
        post.contact = dicr["contact"] as? String
        post.photoUrl = dicr["photoUrl"] as? String
        post.description = dicr["description"] as? String
        
        return post
    }
}
