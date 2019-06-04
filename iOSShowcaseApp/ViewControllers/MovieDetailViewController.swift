//
//  MovieDetailViewController.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 3/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailViewController: UIViewController
{
    @IBOutlet var imgPosterView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var moviesDetailCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton : UIButton?
    
    
    var movieID: Int = 0
    var movieTitle: String = ""
    
    var relatedMovieList = [MovieListKeys]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        callMovieDetailisting(movieID)
        getMovieListing()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - FETCH MOVIES DETAIL fROM SERVER
    
    func callMovieDetailisting(_ movieid: Int)
    {
        activityIndicator.startAnimating()
        let movieServices : MovieServices = MovieServices()
        movieServices.getMoviesDetail(movieid, success: { (response) in
            self.activityIndicator.stopAnimating()
            self.lblTitle.text = response.title
            self.imgPosterView?.sd_setImage(with: response.posterURL, placeholderImage: UIImage(named: "noimage"))
            self.imgPosterView.contentMode = .scaleAspectFit
            self.lblDescription.text = response.overview
            self.navigationItem.title = response.title
        }) { (error) in
            self.activityIndicator.stopAnimating()
            if error?.errorMessage == "The Internet connection appears to be offline."
            {
                self.showToastWithNavigationForNoInternetConnection()
            }
        }
    }
    
    //MARK: - FETCH TOP RATED MOVIES FROM SERVER
    
    func getMovieListing()
    {
        activityIndicator.startAnimating()
        let movieServices : MovieServices = MovieServices()
        movieServices.getMoviesList("top_rated", success: { (movies) in
            self.activityIndicator.stopAnimating()
            self.relatedMovieList = movies.results
            self.moviesDetailCollectionView .reloadData()
            
        }) { (error) in
            self.activityIndicator.stopAnimating()
           if error?.errorMessage == "The Internet connection appears to be offline."
            {
                self.showToastWithNavigationForNoInternetConnection()
            }
        }
    }
    
  
    //MARK: - SET NAVIGATION BAR
    private func setupNavigationBar(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = movieTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 229.0/255.0, green: 63.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton!)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - COLLECTION VIEW CONFIGURATION

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedmovie", for: indexPath) as! MovieCollectionCell
      
        cell.imagePoster.contentMode = .scaleAspectFit
        cell.imagePoster.layer.cornerRadius = 3.0
        cell.imagePoster?.sd_setImage(with: relatedMovieList[indexPath.item].posterURL, placeholderImage: UIImage(named: "noimage"))
        
        // cell.imagePoster.image = movie.
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movID = relatedMovieList[indexPath.item].id
        callMovieDetailisting(movID)
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

