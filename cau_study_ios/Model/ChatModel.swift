//
//  ChatModel.swift
//  cau_study_ios
//
//  Created by 신형재 on 21/07/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import ObjectMapper

class ChatModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    public var users :Dictionary<String,Bool> = [:]
    //채팅방 참여한 사람들
    public var comments :Dictionary<String,Comment> = [:]
    //채팅방 대화내용
    
    public class Comment : Mappable {
        public var uid: String?
        public var message : String?
        public var timestamp : Int?
        
        public required init?(map: Map) {
            
        }
        
        public func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
            timestamp <- map["timestamp"]
        }
        
        
    }
}
