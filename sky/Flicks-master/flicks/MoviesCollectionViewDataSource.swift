

import UIKit
import Kingfisher
class MoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var movies = [Movie]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionCell
        if let url = URL(string: movies[indexPath.row].backdropsURL!.first!){
            cell.posterImageView.contentMode = UIViewContentMode.scaleAspectFill
            cell.posterImageView.clipsToBounds = true
           cell.posterImageView.kf.setImage(with: url)
        }else{
            
                cell.posterImageView.image = #imageLiteral(resourceName: "placeholderImage")
            
        }
        return cell
    }
}
