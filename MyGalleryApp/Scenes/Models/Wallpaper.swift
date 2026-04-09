import Foundation

struct PexelsResponse: Codable {
    let photos: [Wallpaper]
    let totalResults: Int?
    let page: Int?
    let perPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case photos, page
        case totalResults = "total_results"
        case perPage = "per_page"
    }
}

struct Wallpaper: Codable {
    let id: Int
    let photographer: String
    let width: Int
    let height: Int
    let url: String
    let src: PhotoSource
    
    enum CodingKeys: String, CodingKey {
        case id, photographer, width, height, url, src
    }
    
    var thumbnailUrl: String {
        return src.medium
    }
}

struct PhotoSource: Codable {
    let original: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
