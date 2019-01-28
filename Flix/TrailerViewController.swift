//
//  TrailerViewController.swift
//  Flix
//
//  Created by Chase Carnaroli on 1/28/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var movieId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTrailerVideo()
    }
    
    // Get Trailer Video
    //  Sends api request to get a list of videos for the movie
    //  Finds the trailer among the list of videos, and builds a youtube url
    //  Loads youtube url for trailer into webview
    func getTrailerVideo(){
        // Set Up Request
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + movieId + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Get the array of videos
                let videos = dataDictionary["results"] as! [[String:Any]]
                
                // Build video URL
                let trailerKey = self.findTrailerKey(videos: videos)
                let videoUrl = URL(string: "https://www.youtube.com/watch?v=" + trailerKey)!
                let videoRequest = URLRequest(url: videoUrl)
                
                // Load video into webview
                self.webView.load(videoRequest)
            }
        }
        task.resume()
    }
    
    // Find Trailer Key
    //  Finds the key for the trailer
    //  If no trailer video is found, returns first key
    //  If no videos are found, returns a suprise
    func findTrailerKey(videos: [[String:Any]]) -> String {
        if (videos.count > 0) {
            for video in videos {
                if ((video["type"] as! String) == "trailer"){
                    return video["key"] as! String
                }
            }
            return videos[0]["key"] as! String
        } else {
            return "dQw4w9WgXcQ"
        }
    }
    

}
