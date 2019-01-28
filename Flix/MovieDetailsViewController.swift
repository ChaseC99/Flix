//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Chase Carnaroli on 1/27/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title and description
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        // Image base url
        let baseUrl = "https://image.tmdb.org/t/p"
        // Get Movie Poster
        
        let posterResolution = "/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterResolution + posterPath)
        // Set Movie Poster
        posterView.af_setImage(withURL: posterUrl!)
        
        // Get Movie Backdrop
        let backdropPath = movie["backdrop_path"] as! String
        let backdropResolution = "/w780"
        let backdropUrl = URL(string: baseUrl + backdropResolution + backdropPath)
        // Set Movie Backdrop
        backdropView.af_setImage(withURL: backdropUrl!)
    }

    /*
    // MARK: - Navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set movie id
        let id = String(movie["id"] as! Int)
        let trailerViewController = segue.destination as! TrailerViewController
        trailerViewController.movieId = id
    }
 

}
