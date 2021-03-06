//
//  MostViewedTableViewController.swift
//  News
//
//  Created by Roman Topchii on 20.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import UIKit
import Alamofire

class MostViewedViewController: MostEmailedViewController {
    
    override func fetchNews() {
        AF.request("https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=r8k3IwaDanhXOCtIZNjL2MvTqAs3i2yN").responseDecodable(of: NewsData.self) {(response) in
            guard let newsData = response.value else {return}
            self.newsData = newsData
            self.refreshControl.endRefreshing()
        }
    }
}
