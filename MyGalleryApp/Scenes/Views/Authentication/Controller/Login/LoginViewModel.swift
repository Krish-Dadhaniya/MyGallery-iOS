import Foundation
import GoogleSignIn
import UIKit

class LoginViewModel: NSObject {
    
    //MARK: Class Variables
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
//            if let error = error {
//                self.onLoginFailure?(error.localizedDescription)
//                return
//            }
//            
//            guard let user = signInResult?.user else { return }
//            
//            let userId = user.userID ?? ""
//            let name = user.profile?.name ?? ""
//            let email = user.profile?.email ?? ""
//            let profilePic = user.profile?.imageURL(withDimension: 200)?.absoluteString
//            
//            UserSessionManager.shared.saveSession(id: userId, name: name, email: email, profilePic: profilePic)
//            self.onLoginSuccess?()
//        }
        
        
//         Mocking behavior for development until SDK is linked
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UserSessionManager.shared.saveSession(
                id: "12345",
                name: "John Doe",
                email: "john.doe@example.com",
                profilePic: "https://via.placeholder.com/150"
            )
            self.onLoginSuccess?()
        }
    }
}
