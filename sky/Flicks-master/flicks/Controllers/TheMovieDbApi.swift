
import Foundation
import Alamofire
import CodableAlamofire


enum TheMovieDBErrors: Error {
    case networkFail(description: String)
    case jsonSerializationFail
    case dataNotReceived
    case castFail
    case internalError
    case unknown
}

extension TheMovieDBErrors: LocalizedError {
    public var errorDescription: String? {
        let defaultMessage = "Unknown error!"
        let internalErrorMessage = "Something's wrong! Please contact our support team."
        switch self {
        case .networkFail(let localizedDescription):
            print(localizedDescription)
            return localizedDescription
        case .jsonSerializationFail:
            return internalErrorMessage
        case .dataNotReceived:
            return internalErrorMessage
        case .castFail:
            return internalErrorMessage
        case .internalError:
            return internalErrorMessage
        case .unknown:
            return defaultMessage
        }
    }
}


@objc protocol TheMovieDBDelegate: NSObjectProtocol {
    func theMovieDB(didFinishUpdatingMovies movies: [Movie])
    @objc optional func theMovieDB(didFailWithError error: Error)
}

class TheMovieDBApi: NSObject {
    static let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let imageBaseStr: String = "https://image.tmdb.org/t/p/"
    
    var delegate: TheMovieDBDelegate?
    var endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func startUpdatingMovies() {
        var urlRequest = URLRequest(url: URL(string: "https://sky-exercise.herokuapp.com/api/Movies")!)
       //var urlRequest = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(TheMovieDBApi.apiKey)")!)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: urlRequest, completionHandler:
        { (data, response, error) in
            
            
            guard error == nil else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.networkFail(description: error!.localizedDescription))
                print("TheMovieDBApi: \(error!.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.unknown)
                print("TheMovieDBApi: Unknown error. Could not get response!")
                return
            }
            
            guard response.statusCode == 200 else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.internalError)
                print("TheMovieDBApi: Response code was either 401 or 404.")
                return
            }
            
            guard let data = data else {
                self.delegate?.theMovieDB?(didFailWithError: TheMovieDBErrors.dataNotReceived)
                print("TheMovieDBApi: Could not get data!")
                return
            }
            
            do {
                let movies = try self.movieObjects(with: data)
                
                
                print(data)
                print(response)
                self.delegate?.theMovieDB(didFinishUpdatingMovies: movies)
            } catch (let error) {
                self.delegate?.theMovieDB?(didFailWithError: error)
                print("TheMovieDBApi: Some problem occurred during JSON serialization.")
                return
            }
            
        });
        task.resume()
        
                func newJSONDecoder() -> JSONDecoder {
                    let decoder = JSONDecoder()
                    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
                        decoder.dateDecodingStrategy = .iso8601
                    }
                    return decoder
                }
        
                func newJSONEncoder() -> JSONEncoder {
                    let encoder = JSONEncoder()
                    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
                        encoder.dateEncodingStrategy = .iso8601
                    }
                    return encoder
                }
    }
    
    
  
    
    
    func movieObjects(with data: Data) throws -> [Movie] {
        do {

            guard let movieDictionaries =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [NSDictionary] else {
                throw TheMovieDBErrors.castFail
            }

//            guard let movieDictionaries = responseDictionary["results"] as? [NSDictionary] else {
//                print("TheMovieDBApi: Movie dictionary not found.")
//                throw TheMovieDBErrors.unknown
//            }

            return Movie.movies(with: movieDictionaries)

        } catch (let error) {
            print("TheMovieDBApi: \(error.localizedDescription)")
            throw error
        }
    }
    
//    class func loadMovies(onComplete:@escaping (Movie?) -> Void) {
//        let url = "https://sky-exercise.herokuapp.com/api/Movies"
//        Alamofire.request(url).responseJSON {(response) in
//            guard let data = response.data else{
//                print(response)
//                onComplete(nil)
//                return
//            }
//            do{
//                let movieInfo = try? newJSONDecoder().decode(Movie.self, from: data)
//                onComplete(movieInfo)
//                return
//            }catch{
//                print(error.localizedDescription)
//                onComplete(nil)
//            }
//        }
//
//        func newJSONDecoder() -> JSONDecoder {
//            let decoder = JSONDecoder()
//            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//                decoder.dateDecodingStrategy = .iso8601
//            }
//            return decoder
//        }
//
//        func newJSONEncoder() -> JSONEncoder {
//            let encoder = JSONEncoder()
//            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//                encoder.dateEncodingStrategy = .iso8601
//            }
//            return encoder
//        }
//    }
   
}
