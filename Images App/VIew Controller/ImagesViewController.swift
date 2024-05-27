//
//  ImagesViewController.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import UIKit

final class ImagesViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listOfImages: [Image] = []
    private var imageManager = ImageManager()
    private var imgs: [Image] = []
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imageManager.delegate = self
        fetchImages()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    func fetchImages() {
        do {
            try imageManager.performRequest()
        } catch {
            print("Failed to start request: \(error)")
            showAlert(for: error)
        }
    }
    
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        fetchImages()
    }
    
    //MARK: Search Handler
    @IBAction func textFieldSearching(_ sender: UITextField) {
        if let searchText = sender.text {
            imgs = searchText.isEmpty ? listOfImages : listOfImages.filter{$0.title.lowercased().contains(searchText.lowercased())}
            
            collectionView.reloadData()
        }
    }
    
    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! ImageDetailViewController
                destinationController.img = imgs[indexPath[0].row].url
                collectionView.deselectItem(at: indexPath[0], animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.configure(with: imgs[indexPath.row].title, image: imgs[indexPath.row].thumbnailUrl)
        
        return cell
    }
}


extension ImagesViewController: ImageManagerDelegate {
    
    func didFetchImages(_ images: [Image]) {
//        print("chotam")
        listOfImages = images
        imgs = images
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func didFailWithError(_ error: Error) {
        refreshControl.endRefreshing()
        showAlert(for: error)
        print(error)
    }
}


extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            return CGSizeMake((collectionView.frame.size.width-48)/3, collectionView.frame.size.height-10/1)
        }
        else{
            return CGSize(width: collectionView.frame.width - 32, height: (collectionView.frame.height - 32) / 3)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    }
}
