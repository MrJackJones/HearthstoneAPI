//
//  MainTableViewController.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NetworkManager.shared.fetchAlamofireCards { result in
            switch result {
                
            case .success(let cards):
                self.cards = cards
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        let card = cards[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = card.name
        
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: card)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController else {return}
        guard let card = sender as? Card else {return}
        detailsVC.card = card
    }
    
    
}
