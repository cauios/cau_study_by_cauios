//
//  NotificationModel.swift
//  cau_study_ios
//
//  Created by 신형재 on 20/08/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationModel: Mappable {
    
    public var to : String?
    public var notification: Notification = Notification()
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        to <- map["to"]
        notification <- map["notification"]
    }
    
    class Notification :Mappable{
        public var title : String?
        public var text : String?
        
        init(){
            
        }
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            title <- map["title"]
            text <- map["text"]
        }
        
    }
}
