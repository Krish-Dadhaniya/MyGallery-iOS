import UIKit

class ProfileVC: UIViewController {
    
    
    //MARK: Outlet
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
        var viewModel: ProfileViewModel!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(ProfileVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.populateData()
    }
    
    private func populateData() {
        lblName.text = viewModel.userName
        lblEmail.text = viewModel.userEmail
        
        if let urlString = viewModel.userProfilePicUrl, let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                if let image = image {
                    self?.imgProfile.image = image
                } else {
                    self?.imgProfile.image = UIImage(named: "imgUserProfile")
                }
            }
        } else {
            imgProfile.image = UIImage(named: "imgUserProfile")
        }
    }
    
    private func applyStyle() {
        self.navigationItem.title = "Profile"
        
        vwContainer.layer.cornerRadius = 20
        vwContainer.clipsToBounds = true
        vwContainer.backgroundColor = .white
        vwContainer.applyShadow(opacity: 0.2, radius: 20)
        
        imgProfile.clipsToBounds = true
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.colorThemeBlue.cgColor
        
        lblName.font = UIFont.customFont(22, .bold)
        lblName.textColor = .black
        
        lblEmail.font = UIFont.customFont(16, .medium)
        lblEmail.textColor = .gray
        
        btnLogout.configure(
            title: "Log out",
            image: .icLogout,
            backgroundColor: .colorThemeRed.withAlphaComponent(0.2),
            titleColor: .colorThemeRed
        )
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        viewModel.logout()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let loginVC = storyboard.instantiateInitialViewController()
            window.rootViewController = loginVC
        }) { _ in
            window.makeKeyAndVisible()
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ProfileViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
