//
//  CategoryApi.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 7. 29..
//  Copyright © 2018년 신형재. All rights reserved.
//

import Foundation
import FirebaseDatabase
class CategoryApi {
    var REF_CATEGORY = Database.database().reference().child("category")
    var REF_CATEGORY_ACADEMIC = Database.database().reference().child("category").child("academic")
    var REF_CATEGORY_EMPLPREP = Database.database().reference().child("category").child("emplprep")
    var REF_CATEGORY_LANGUAGE = Database.database().reference().child("category").child("language")
}
