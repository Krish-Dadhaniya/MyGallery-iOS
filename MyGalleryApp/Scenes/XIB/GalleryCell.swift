//
//  GalleryCell.swift
//  MyGalleryApp
//
//  Created by Rutvik Khunt on 08/04/26.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var imgWallPaper: UIImageView!
    
    //------------------------------------------------------
    
    //MARK: Class Variable

    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgWallPaper.layer.cornerRadius = 5
        imgWallPaper.clipsToBounds = true
        imgWallPaper.backgroundColor = .systemGray6
    }
    
    func configure(with wallpaper: Wallpaper) {
        guard let url = URL(string: wallpaper.thumbnailUrl) else { return }
        
//        imgWallPaper.image = nil
        
        ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
            self?.imgWallPaper.image = image
        }
    }
    

}
