//
//  MoviesGridViewController.swift
//  Flix
//
//  Created by Chase Carnaroli on 1/27/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // CollectionView Setup
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // CollectionView layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2)/3
        let posterSize = CGSize(width: width, height: width*1.5)
        layout.itemSize = posterSize
        
        // Load superhero movies
        getSuperheroMovies()
    }
    
    // Get Superhero Movies
    //  Sends api request to get a list of movies now playing
    //  Updates the variable movies with the results
    func getSuperheroMovies() {
        // Set Up Request
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Get the array of movies
                self.movies = dataDictionary["results"] as! [[String:Any]]
                print(self.movies)
                
                // Reload table view data
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    /*
     // MARK: - CollectionView Functions
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        // Get Movies
        let movie = movies[indexPath.row]
        
        // Get Movie Poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Set Movie Poster
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }

    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find selected movie
        let movieCell = sender as! MovieGridCell
        let indexPath = collectionView.indexPath(for: movieCell)
        let movie = movies[indexPath!.row]
        
        // Pass movie details to the view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
    }
}
