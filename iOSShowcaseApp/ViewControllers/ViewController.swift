//
//  ViewController.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 3/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var moviesCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var refreshButton: UIButton!
    
    var movies = [MovieListKeys]() {
        didSet {
            moviesCollectionView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getMovieListing()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - NAVIGATION BAR SETUP
    private func setupNavigationBar(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 229.0/255.0, green: 63.0/255.0, blue: 44.0/255.0, alpha: 1.0)
         self.navigationItem.leftBarButtonItem = nil
    }
    
    //MARK: - FETCH MOVIES FROM API

    func getMovieListing()
    {
        activityIndicator.startAnimating()
        refreshButton.isHidden = true
        let movieServices : MovieServices = MovieServices()
        movieServices.getMoviesList("now_playing", success: { (movies) in
            self.activityIndicator.stopAnimating()
            self.movies = movies.results
            self.moviesCollectionView .reloadData()
           
        }) { (error) in
            self.activityIndicator.stopAnimating()
             self.refreshButton.isHidden = false
            if error?.errorMessage == "The Internet connection appears to be offline."
            {
               self.showToastWithNavigationForNoInternetConnection()
            }
            
        }
    }
    
    func showToastWithNavigationForNoInternetConnection(){
        self.navigationController?.view.makeToast() { didTap in
            if didTap {
                print("completion from tap")
            } else {
                print("completion without tap")
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getMovieListing()
    }
}


//MARK: - COLLECTION VIEW CONFIGURATION
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieList", for: indexPath) as! MovieCollectionCell
        cell.title.text = movies[indexPath.item].title
        cell.imagePoster.contentMode = .scaleAspectFit
        cell.imagePoster.layer.cornerRadius = 3.0
        cell.imagePoster?.sd_setImage(with: movies[indexPath.item].posterURL, placeholderImage: UIImage(named: "noimage"))
       // cell.imagePoster.image = movie.
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailVC = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.movieID = movies[indexPath.item].id
        movieDetailVC.movieTitle = movies[indexPath.item].title
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width/3.0
        return CGSize(width: cellWidth, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

