//
//  DetailsViewController.swift
//  HearthstoneAPI
//
//  Created by Ivan on 12.04.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        updateLabel()
    }
}

extension DetailsViewController {
    func getImage() {
        if let image = card.img {
            NetworkManager.shared.fetchAlamofireImage(imageUrl: image) { result in
                switch result {
                case .success(let image):
                    guard let image = UIImage(data: image) else {return}
                    self.cardImageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateLabel() {
        let text = card.text ?? ""
        title = card.name
        textLabel.attributedText = text.htmlAttributedString()
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        costLabel.text = "\(card.cost)"
        attackLabel.text = "\(card.attack)"
        healthLabel.text = "\(card.health ?? 0)"
    }
}

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }
}
