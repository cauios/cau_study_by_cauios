

import Foundation


class User {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var uid: String?
    var introduceMyself: String?
    var saved: String?
    //var pushToken: String?
}


extension User {
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.introduceMyself = dict["introduceMyself"] as? String
        user.uid = key
        //user.pushToken = dict["pushToken"] as? String
        return user
    }
}
