import Foundation


class GalleryViewModel: NSObject {
    
    //MARK: Class Variables
    private(set) var arrWallpapers: [Wallpaper] = []
    private(set) var isFetching = false
    private(set) var hasMoreData = true
    private var currentPage = 1
    private let limit = 12
    private let pexelsApiKey = "1qi0HGpKwA2sadlzVNeAkpGPnKuce5sDUkKEzGBUW2Wiz9I3uCsiQLpB" 
    
    var onDataUpdate: (([IndexPath]?) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStatusChange: ((Bool) -> Void)?
    
    //MARK: Init
    override init() {
        super.init()
        loadCachedData()
    }
    
    //MARK: Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK: Custom Methods
    
    private func loadCachedData() {
        if let cached: [Wallpaper] = ImageCacheManager.shared.getItems("cachedWallpapers") {
            self.arrWallpapers = cached
            self.onDataUpdate?(nil)
        }
    }
    
    func fetchWallpapers(isInitial: Bool = false) {
        guard !isFetching, (isInitial || hasMoreData) else { return }
        
        if isInitial {
            currentPage = 1
            hasMoreData = true
        }
        
        isFetching = true
        onLoadingStatusChange?(true)
        
        let urlString = "https://api.pexels.com/v1/search?query=wallpaper&page=\(currentPage)&per_page=\(limit)"
        debugPrint(" Fetching Pexels page \(currentPage): \(urlString)")
        
        guard let url = URL(string: urlString) else {
            isFetching = false
            onLoadingStatusChange?(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(pexelsApiKey, forHTTPHeaderField: "Authorization")
        
        ImageCacheManager.shared.session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isFetching = false
                self.onLoadingStatusChange?(false)
                
                if let error = error {
                    debugPrint(" Pexels fetch error: \(error.localizedDescription)")
                    if self.arrWallpapers.isEmpty {
                        self.onError?(error.localizedDescription)
                    }
                    return
                }
                
                guard let data else { return }
                
                do {
                    let result = try JSONDecoder().decode(PexelsResponse.self, from: data)
                    let newItems = result.photos
                    
                    debugPrint(" Fetched \(newItems.count) wallpapers from Pexels")
                    
                    var newIndexPaths: [IndexPath]? = nil
                    
                    if isInitial {
                        self.arrWallpapers = newItems
                        ImageCacheManager.shared.saveItems(newItems, forKey: "cachedWallpapers")
                        newIndexPaths = nil
                    } else {
                        // Append new results
                        let startIndex = self.arrWallpapers.count
                        self.arrWallpapers.append(contentsOf: newItems)
                        newIndexPaths = (startIndex..<self.arrWallpapers.count).map { IndexPath(item: $0, section: 0) }
                    }
                    
                    let totalAvailable = result.totalResults ?? 0
                    if self.arrWallpapers.count >= totalAvailable || newItems.isEmpty {
                        self.hasMoreData = false
                    }
                    
                    self.currentPage += 1
                    self.onDataUpdate?(newIndexPaths)
                    
                } catch {
                    debugPrint(" Pexels parsing error: \(error)")
                    // Fallback to cached data if parsing fails
                    if self.arrWallpapers.isEmpty {
                        self.onError?("Failed to parse response")
                    }
                }
            }
        }.resume()
    }
}
