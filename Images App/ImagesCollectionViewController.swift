//
//  ImagesCollectionViewController.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

final class ImagesCollectionViewController: UICollectionViewController {
    
//    private let images = ["image1", "image2", "image3", "image4", "image5"]
    private var listOfImages: [Image] = []
    private var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageManager.delegate = self
        imageManager.performRequest()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listOfImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.configure(with: listOfImages[indexPath.row].title, image: listOfImages[indexPath.row].url)
        
        return cell
    }
    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
            
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! ImageDetailViewController
                destinationController.img = listOfImages[indexPath[0].row].thumbnailUrl
                collectionView.deselectItem(at: indexPath[0], animated: false)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    
    /*
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

extension ImagesCollectionViewController: ImageManagerDelegate {
    func didFetchImages(_ images: [Image]) {
        listOfImages = images
        collectionView.reloadData()

    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: (view.frame.height - 32) / 3)
    }
}
