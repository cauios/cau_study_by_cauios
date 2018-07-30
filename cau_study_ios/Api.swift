//
//  Api.swift
//  cau_study_ios
//
//  Created by 신형재 on 20/03/2018.
//  Copyright © 2018 신형재. All rights reserved.
//
// [Dahye's comment] We put all shared Api stances in this common place for convenience.
import Foundation
struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Saved = SavedApi()
    static var MyPosts = MyPostsApi()
    static var HashTag = HashTagApi()
    static var Category = CategoryApi()
}
