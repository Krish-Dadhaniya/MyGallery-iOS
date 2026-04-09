
import UIKit

class LoginVC: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    @IBOutlet weak var imgLogin: UIImageView!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: LoginViewModel!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(LoginVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.setupBindings()
    }
    
    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            self?.redirectToGallery()
        }
        
        viewModel.onLoginFailure = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func applyStyle() {
    
        self.title = "Login"
        if let navBar = self.navigationController?.navigationBar {
            navBar.titleTextAttributes = [
                .foregroundColor: UIColor(named: "colorThemeBlue") ?? .blue,
                .font: UIFont.customFont(18, .bold)
            ]
        }
        
        lblWelcome.text = "Welcome to\nMyGallery"
        lblWelcome.font = UIFont.customFont(32, .bold)
        lblWelcome.textColor = .darkGray
        
        lblSubtitle.text = "Explore beautiful wallpapers"
        lblSubtitle.font = UIFont.customFont(16, .medium)
        lblSubtitle.textColor = .gray
        
        btnCreateAccount.configure(
            title: "Create an Account",
            image: nil,
            backgroundColor: .clear,
            titleColor: .white
        )
        btnGoogleLogin.configure(
            title: "Continue with Google",
            image: .icGoogle,
            backgroundColor: .white,
            titleColor: .black
        )
        
        btnGoogleLogin.layer.borderWidth = 1
        btnGoogleLogin.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        setupTermsAndPrivacyLabel()
    }
        
    private func setupTermsAndPrivacyLabel() {
        let fullText = "By continuing, you agree to our Terms of Service and acknowledge our Privacy Policy."
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.font, value: UIFont.customFont(12, .regular), range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: fullText.count))
        
        let termsRange = (fullText as NSString).range(of: "Terms of Service")
        let privacyRange = (fullText as NSString).range(of: "Privacy Policy")
        
        let linkColor = UIColor.colorThemeBlue
        
        attributedString.addAttribute(.foregroundColor, value: linkColor, range: termsRange)
        attributedString.addAttribute(.font, value: UIFont.customFont(12, .semiBold), range: termsRange)
        
        attributedString.addAttribute(.foregroundColor, value: linkColor, range: privacyRange)
        attributedString.addAttribute(.font, value: UIFont.customFont(12, .semiBold), range: privacyRange)
        
        lblTermsAndPrivacy.attributedText = attributedString
        lblTermsAndPrivacy.textAlignment = .center
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    @IBAction func btnGoogleLoginTapped(_ sender: UIButton) {
        viewModel.signInWithGoogle(presentingViewController: self)
    }
    
    @IBAction func btnCreateAccountTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Join Us!", message: "Account creation is coming soon in the next update. Stay tuned!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exciting!", style: .default))
        self.present(alert, animated: true)
    }
    
    //MARK: Navigation
    private func redirectToGallery() {
        if let galleryVC = self.storyboard?.instantiateViewController(withIdentifier: "GalleryVC") as? GalleryVC {
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = LoginViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnCreateAccount.applyGradient(
            colors: [UIColor.colorDarkGredient, UIColor.colorLightGredient],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        
        btnGoogleLogin.layer.cornerRadius = btnGoogleLogin.frame.height / 2
        btnCreateAccount.layer.cornerRadius = btnCreateAccount.frame.height / 2
        btnCreateAccount.updateGradientFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
