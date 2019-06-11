/*
 * Confess It
 *
 * This app is provided as-is with no warranty or guarantee
 * See the license file under "Confess It" -> "License" ->
 * "License.txt"
 *
 * Copyright © 2019 Brick Water Studios
 *
 */

import UIKit

class ConfessController: UITableViewController {
    let welcome = """
            Welcome to Confess It! The app to get whatever you want off your chest.

            We know rules suck, but there is only one, please keep the dirty stuff to a minimum! Beyond that, tap + to create a new confession, anything above this post are since you opened the app, anything below are older! If you really like, share us with your friends!
        """
    var server: CIServer!

    override func viewDidLoad() {
        super.viewDidLoad()
        server = CIServer()
        server.delegate = self
        server.subscribe()
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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if confessions[indexPath.row].story != welcome {
            let report = UIContextualAction(style: .normal, title: "Report") { _, _, action in
                self.server.report(confessions[indexPath.row])
                action(true)
            }
            return UISwipeActionsConfiguration(actions: [report])
        }
        return nil
    }
    
    // MARK: - IBActions
    
    @IBAction func didPressNew() {
        performSegue(withIdentifier: "newConfession", sender: self)
    }
    
    @objc
    func refresh() {
        server.update { success in
            if success {
                confessions.sort(by: { $0.published > $1.published })
                confessions.insert(Confession(story: self.welcome), at: 0)
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
}

extension ConfessController: CIServerDelegate {
    func didFailShare(_ error: Error) {
        let alert = UIAlertController(title: "Oh No!", message: "That confession was so powerful, it broke our sharing engine! Please try again when the engine is done crying over the power of that confession!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func confessionDidUpdate() {
        tableView.reloadData()
    }
    
    func confessionUpdateError(_ error: Error) {
        NSLog("CIConfessError:: " + error.localizedDescription)
    }
    
    func reportDidSucceed() {
        let alert = UIAlertController(title: "Success", message: "You have successfully faught the foe! If enough people stand to fight, we will stand with you and remove the bad confession!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func reportDidFail(_ error: Error) {
        let alert = UIAlertController(title: "Oh No!", message: "We seam to have run into a problem with your report. It vanished. We searched far and wide, but the little bugger just couldn't be found! Please try again and we will try not to loose this one!", preferredStyle: .alert)
        let ty = UIAlertAction(title: "I'll Try", style: .default, handler: nil)
        let nt = UIAlertAction(title: "No Thanks", style: .default, handler: nil)
        alert.addAction(ty); alert.addAction(nt)
        present(alert, animated: true, completion: nil)
    }
}
