//
//  ConfessController.swift
//  Confess It
//
//  Created by Erik Bean on 5/26/19.
//  Copyright © 2019 Brick Water Studios. All rights reserved.
//

import UIKit

class ConfessController: UITableViewController {
    let welcome = """
            Welcome to Confess It! The app to get whatever you want off your chest.

            We know rules suck, but there is only one, please keep the dirty stuff to a minimum! Beyond that, tap + to create a new confession, anything above this post are since you opened the app, anything below are older! If you really like, share us with your friends!
        """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe {
            self.tableView.reloadData()
        }
        
        confessions.append(Confession(story: welcome))
        tableView.reloadData()
        
        tableView.register(UINib(nibName: "ConfessCell", bundle: nil), forCellReuseIdentifier: "cell")
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl = r
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConfessCell
        let con = confessions[indexPath.row]
        cell.story!.text = con.story
        cell.confession = con
        cell.background.backgroundColor = con.background
        if let author = con.author {
            cell.author!.text = "- " + author
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Use leadingSwipeActionsConfigurationForRowAt and UIContextualAction instead
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        if confessions[indexPath.row].story == welcome {
//            let report = UITableViewRowAction(style: .destructive, title: "Report") { action, indexPath in
//
//            }
//            return [report]
//        } else { return nil }
//    }
    
    // MARK: - IBActions
    
    @IBAction func didPressNew() {
        performSegue(withIdentifier: "newConfession", sender: self)
    }
    
    @objc
    func refresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

}
