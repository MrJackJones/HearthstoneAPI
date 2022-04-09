//
//  CardTableViewCell.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var destiptionsLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var cardImageView: UIImageView!
    
    func configure(with card: Card) {
        nameLabel.text = card.name
        destiptionsLabel.text = card.text ?? ""
        costLabel.text = "\(card.cost)"
        attackLabel.text = "\(card.attack)"
        healthLabel.text = "\(card.health ?? 0)"
        
        if let image = card.img {
            NetworkManager.getImage(imageUrl: image) { image in
                self.cardImageView.image = image
            }
        }
    }
}
