//
//  ImageCollectionViewCell.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import UIKit
import SDWebImage


final class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imagesView.layer.cornerRadius = 20
    }
    
    func configure(with name: String, image: String) {
        imageNameLabel.text = name
        self.imagesView.sd_setImage(with: URL(string: image))
    }
}
