import UIKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private let fileManager = FileManager.default
    private let memoryCache = NSCache<NSString, UIImage>()
    
    let session: URLSession
    
    private init() {
        memoryCache.countLimit = 100
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 45
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    private var cacheDirectory: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        let fileName = url.absoluteString.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        // 1. Check memory cache
        if let cachedImage = memoryCache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        // 2. Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key)
            completion(image)
            return
        }
        
        // 3. Download from web
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                debugPrint(" Image download error for \(url): \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                debugPrint(" Failed to decode image data for \(url)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Save to memory
            self.memoryCache.setObject(image, forKey: key)
            
            // Save to disk
            self.saveToDisk(data: data, fileName: fileName)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    private func saveToDisk(data: Data, fileName: String) {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
    
    // MARK: - List Caching (Offline Support)
    
    func saveItems<T: Codable>(_ items: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func getItems<T: Codable>(_ key: String) -> [T]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let items = try? JSONDecoder().decode([T].self, from: data) {
            return items
        }
        return nil
    }
}
