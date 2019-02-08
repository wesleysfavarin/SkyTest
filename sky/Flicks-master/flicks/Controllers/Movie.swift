

import Foundation

//typealias Movie = [MovieElement]

class Movie: NSObject {
    private(set)var title, overview, duration, releaseYear: String?
    private(set)var coverURL: String
    private(set)var backdropsURL: [String]?
    
    
    enum CodingKeys: String, CodingKey {
        case title, overview, duration
        case releaseYear = "release_year"
        case coverURL = "cover_url"
        case backdropsURL = "backdrops_url"
        case id
    }
    
    init(dictionary: NSDictionary) {
        let title = dictionary["title"] as? String
        let overview = dictionary["overview"] as? String
        let duration = dictionary["duration"] as? String
         let releaseYear = (dictionary["release_year"] as? String)?.characters.split(separator: "-").map {String($0)}[0]
        let coverURL = dictionary["cover_url"] as! String
        
        
        
        let backdropsURL = dictionary["backdrops_url"] as? [String]
        self.backdropsURL = backdropsURL
        
        
        self.coverURL = coverURL
        self.title = title
        self.overview = overview
        self.duration = duration
        self.releaseYear = releaseYear
        
       
    }
    class func movies(with dictionaries: [NSDictionary]) -> [Movie] {
        return dictionaries.map {Movie(dictionary: $0)}
    }
}
