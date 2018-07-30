

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUserByUsername(username: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(completion: @escaping (User) -> Void) {
        REF_USERS.observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    func changeProfileImage(currentUserUid: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(currentUserUid)
        //형재 firebase 5버전 이상을 위한 수정
        storageRef.putData(imageData,metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image")
                return
            }else {
                print("Uploaded")
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    Api.User.REF_USERS.child(currentUserUid).updateChildValues(["profileImageUrl" : url!.absoluteString])
                    onSuccess()
                })
            }
        })
        
    }
    
    func changeProfileInfo(currentUserUid: String, introduceString: String, username: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        let newUserRef = Api.User.REF_USERS.child(currentUserUid)
        newUserRef.updateChildValues(["introduceMyself": introduceString ,"username": username], withCompletionBlock: { error, ref in
            if error != nil {
                return
            }
            onSuccess()
        })
    }
    
    func deleteUserProfile(userId: String, onSuccess: @escaping () -> Void, onError: @escaping(_ errorMessage: String?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(userId)
        storageRef.delete(completion: {error in
            if error != nil {
                return
            }
            onSuccess()
        })
    }
    
    
    
    /*var CURRENT_USER: User? {
     if let currentUser = Auth.auth().currentUser{
     return currentUser
     }
     
     return nil
     }//이부분 수정*/
    
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
}

