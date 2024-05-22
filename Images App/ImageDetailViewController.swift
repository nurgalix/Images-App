//
//  ImageDetailViewController.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    var img: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.sd_setImage(with: URL(string: img!))
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
}
