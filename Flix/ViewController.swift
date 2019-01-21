//
//  ViewController.swift
//  Flix
//
//  Created by Chase Carnaroli on 1/20/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var movies = [[String:Any]]()
    var filteredMovies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        getMovies()
    }
    
    // Mark: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // Get Movie Information
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        // Set Movie Information
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        // Get Movie Poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Set Movie Poster
        cell.pictureView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // Mark: SearchController Functinos
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if(searchBarIsEmpty()) {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter({( movie : [String:Any]) -> Bool in
                return (movie["title"] as! String).lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }

    
    // Get Movies
    //  Sends api request to get a list of movies now playing
    //  Updates the variable movies with the results
    func getMovies() {
        // Set Up Request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.filteredMovies = self.movies
                print(self.movies)
                
                // Reload table view data
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
}

