

import UIKit
import Kingfisher

class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var movies = [Movie]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skyCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overViewLabel.text = movie.overview
        cell.releaseYearLabel.text = movie.releaseYear
        
    let urlback = URL(string: movie.backdropsURL!.last!)
            cell.posterImageView.kf.setImage(with: urlback)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
}
