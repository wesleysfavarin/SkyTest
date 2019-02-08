

import UIKit
import Kingfisher
class MovieDetailViewController: UIViewController {
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var overViewLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: contentView.frame.origin.y + contentView.frame.height)
        self.navigationItem.title = movie.title
        overViewLabel.text = movie.overview
        overViewLabel.sizeToFit()
        
        if let url = URL(string: movie.backdropsURL!.first!){
            backdropImageView.kf.indicatorType = .activity
            backdropImageView.kf.setImage(with: url)
        }else{
                backdropImageView.image = #imageLiteral(resourceName: "placeholderImage")
        }

    }
    
    func setImage(with smallImageURL: URL, largeImageURL: URL) {
        let smallImageRequest = URLRequest(url: smallImageURL)
        self.backdropImageView.setImageWith(
            smallImageRequest,
            placeholderImage: #imageLiteral(resourceName: "placeholderImage"),
            success: {
                (_, _, smallImage) in
                self.backdropImageView.alpha = 0.0
                self.backdropImageView.image = smallImage
                UIView.animate(
                    withDuration: 0.3,
                    animations: {self.backdropImageView.alpha = 1.0})
                { _ in self.backdropImageView.setImageWith(largeImageURL) }
        },
            failure: { _ in self.backdropImageView.image = nil })
    }
    
}
