//
//  FavoriteArticlesTableViewController.swift
//  News
//
//  Created by Roman Topchii on 20.05.2020.
//  Copyright © 2020 Roman Topchii. All rights reserved.
//

import UIKit
import CoreData

class FavoriteArticlesTableViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.shared
    lazy var fetchedResultsController : NSFetchedResultsController<FavoriteArticle> = {
        let fetchRequest : NSFetchRequest<FavoriteArticle> = NSFetchRequest<FavoriteArticle>(entityName: "FavoriteArticle")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        }
        catch let error {
            print("ERROR: ", error.localizedDescription)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ArticleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteArticleCell_ID", for: indexPath) as! ArticleTableViewCell
        cell.articleImage.image = nil
        cell.titleLabel.text = nil
        cell.abstractLabel.text = nil
        let article  = fetchedResultsController.object(at: indexPath) as FavoriteArticle
        if let title = article.title, let dataImage = article.image, let abstract = article.abstract {
            cell.articleImage.image = UIImage(data: dataImage)
            cell.titleLabel.text = title
            cell.abstractLabel.text = abstract
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = fetchedResultsController.object(at: indexPath) as FavoriteArticle
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC_ID") as! DetailViewController
        if let htmlBody = selectedArticle.htmlBody {
            vc.html = htmlBody
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataStack.deleteArticle(fetchedResultsController.object(at: indexPath) as FavoriteArticle)
            do {
                try fetchedResultsController.performFetch()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            catch let error {
                print("ERROR: ", error.localizedDescription)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
