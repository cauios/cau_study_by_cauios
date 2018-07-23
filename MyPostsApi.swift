//
//  MyPostsApi.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 10..
//  Copyright © 2018년 신형재. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
}
