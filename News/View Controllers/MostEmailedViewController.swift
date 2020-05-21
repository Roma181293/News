//
//  ViewController.swift
//  News
//
//  Created by Roman Topchii on 19.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import UIKit
import Alamofire

class MostEmailedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coreDataStack = CoreDataStack.shared
    var newsData : NewsData? {
        didSet {
            tableView.reloadData()
        }
    }
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshNewsData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching News ...")
        
        fetchNews()
    }
    
    @objc private func refreshNewsData(_ sender: Any) {
        fetchNews()
    }
    
    func fetchNews() {
        AF.request("https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=r8k3IwaDanhXOCtIZNjL2MvTqAs3i2yN").responseDecodable(of: NewsData.self) {(response) in
            guard let newsData = response.value else {return}
            self.newsData = newsData
            self.refreshControl.endRefreshing()
        }
    }
}

extension MostEmailedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let newsData = newsData {
            return newsData.results.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ArticleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell_ID", for: indexPath) as! ArticleTableViewCell
        if let newsData = newsData {
            
            cell.articleImage.image = nil
            cell.titleLabel.text = nil
            cell.abstractLabel.text = nil
            
            if let media = newsData.results[indexPath.row].media.first, let mediaMetaData = media.mediaMetaData.last, let url = URL(string: mediaMetaData.url){
                cell.articleImage.load(url: url, placeholder: UIImage(named:"NoAvailable"))
            }
            else {
                cell.articleImage.image = UIImage(named:"NoAvailable")
            }
             cell.titleLabel.text = newsData.results[indexPath.row].title
             cell.abstractLabel.text = newsData.results[indexPath.row].abstract
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC_ID") as! DetailViewController
        if let newsData = newsData {
            vc.url = URL(string: newsData.results[indexPath.row].url)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavorite = UIContextualAction(style: .destructive, title: "Favorite") { _, _, complete in
            if let newsData = self.newsData, let image = (tableView.cellForRow(at: indexPath)as!ArticleTableViewCell).articleImage.image, let imageData = image.pngData() {
                let article = newsData.results[indexPath.row]
                
                AF.request(newsData.results[indexPath.row].url).responseString() {(response) in
                    if let htmlBody = response.value {
                        self.coreDataStack.addArticleToFavorites(url: article.url, title: article.title, abstract: article.abstract, htmlBody: htmlBody, imageData: imageData)
                    }
                }
            }
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [addToFavorite])
        configuration.actions[0].backgroundColor = .systemGreen
        return configuration
    }
}

