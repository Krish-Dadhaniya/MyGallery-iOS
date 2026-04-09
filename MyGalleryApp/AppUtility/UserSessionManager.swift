import Foundation

class UserSessionManager {
    
    static let shared = UserSessionManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userId = "userId"
        static let userName = "userName"
        static let userEmail = "userEmail"
        static let userProfilePic = "userProfilePic"
    }
    
    private init() {}
    
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Keys.isLoggedIn) }
        set { defaults.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    var userId: String? {
        get { defaults.string(forKey: Keys.userId) }
        set { defaults.set(newValue, forKey: Keys.userId) }
    }
    
    var userName: String? {
        get { defaults.string(forKey: Keys.userName) }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }
    
    var userEmail: String? {
        get { defaults.string(forKey: Keys.userEmail) }
        set { defaults.set(newValue, forKey: Keys.userEmail) }
    }
    
    var userProfilePic: String? {
        get { defaults.string(forKey: Keys.userProfilePic) }
        set { defaults.set(newValue, forKey: Keys.userProfilePic) }
    }
    
    func saveSession(id: String, name: String, email: String, profilePic: String?) {
        self.userId = id
        self.userName = name
        self.userEmail = email
        self.userProfilePic = profilePic
        self.isLoggedIn = true
    }
    
    func clearSession() {
        defaults.removeObject(forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.userId)
        defaults.removeObject(forKey: Keys.userName)
        defaults.removeObject(forKey: Keys.userEmail)
        defaults.removeObject(forKey: Keys.userProfilePic)
        defaults.synchronize()
    }
}
