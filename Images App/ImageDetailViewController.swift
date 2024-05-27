//
//  ImageDetailViewController.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import UIKit
import Kingfisher

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    var img: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = img, let url = URL(string: img) {
            imageView.kf.setImage(with: url)
        } else {
            print("Invalid image URL")
                self.imageView.image = nil 
            }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
}
