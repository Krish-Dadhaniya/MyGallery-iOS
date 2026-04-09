import Foundation

class ProfileViewModel: NSObject {
    
    //MARK: Class Variables
    var userName: String {
        return UserSessionManager.shared.userName ?? "Guest User"
    }
    
    var userEmail: String {
        return UserSessionManager.shared.userEmail ?? "No Email"
    }
    
    var userProfilePicUrl: String? {
        return UserSessionManager.shared.userProfilePic
    }
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
    func logout() {
        UserSessionManager.shared.clearSession()
    }
}
