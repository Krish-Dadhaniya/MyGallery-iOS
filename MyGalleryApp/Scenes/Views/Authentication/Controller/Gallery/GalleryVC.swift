import UIKit

class GalleryVC: UIViewController {
    
    
    //MARK: Outlet
    
    @IBOutlet weak var colGallery: UICollectionView!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: GalleryViewModel!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(GalleryVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.setupBindings()
        
        let nib = UINib(nibName: "GalleryCell", bundle: nil)
        self.colGallery?.register(nib, forCellWithReuseIdentifier: "GalleryCell")
        self.colGallery?.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingFooterView")
        self.colGallery?.delegate = self
        self.colGallery?.dataSource = self
        
        viewModel.fetchWallpapers(isInitial: true)
    }
    
    private func setupBindings() {
        viewModel.onDataUpdate = { [weak self] indexPaths in
            if let indexPaths = indexPaths {
                self?.colGallery.insertItems(at: indexPaths)
            } else {
                self?.colGallery.reloadData()
            }
        }
        
        viewModel.onLoadingStatusChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.colGallery.collectionViewLayout.invalidateLayout()
            }
        }
        
        viewModel.onError = { message in
            debugPrint("Error fetching wallpapers: \(message)")
        }
    }
    
    private func applyStyle() {
        self.navigationItem.hidesBackButton = true
    
        let titleLabel = UILabel()
        titleLabel.text = "Gallery"
        titleLabel.textColor = UIColor.colorThemeBlue
        titleLabel.font = UIFont.customFont(20, .bold)
        self.navigationItem.titleView = titleLabel
        
        setupProfileButton()
        
        if let layout = colGallery.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
            layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    private func setupProfileButton() {
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .lightGray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        if let urlString = UserSessionManager.shared.userProfilePic, let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url) { image in
                profileImageView.image = image ?? UIImage(named: "imgUserProfile")
            }
        } else {
            profileImageView.image = UIImage(named: "imgUserProfile")
        }
        
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileImageView.addGestureRecognizer(tapGesture)
        
        let leftBarButton = UIBarButtonItem(customView: profileImageView)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func openProfile() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = GalleryViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

//------------------------------------------------------

//MARK: UICollectionView Delegate and Datasource

extension GalleryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrWallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let wallpaper = viewModel.arrWallpapers[indexPath.item]
        cell.configure(with: wallpaper)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = viewModel.arrWallpapers[indexPath.item]
        let detailVC = FullScreenImageVC(wallpaper: wallpaper)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 45 // 15 (left) + 15 (right) + 15 (middle)
        let width = (collectionView.frame.width - padding) / 2
        return CGSize(width: width, height: width) // Square cells
    }
    
    // MARK: - Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        guard !viewModel.isFetching && viewModel.hasMoreData else { return }
        
        if offsetY > contentHeight - frameHeight - 150 {
            viewModel.fetchWallpapers()
        }
    }
    
    // MARK: - Footer Implementation
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingFooterView", for: indexPath) as! LoadingFooterView
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isFetching && viewModel.hasMoreData {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        return .zero
    }
}

// MARK: - Loading Footer View
class LoadingFooterView: UICollectionReusableView {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.colorThemeBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
