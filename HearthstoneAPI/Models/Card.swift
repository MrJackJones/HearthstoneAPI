//
//  Card.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import Foundation
import UIKit

struct Card: Codable {
    let name: String
    let cost: Int
    let attack: Int
    let health: Int?
    let text: String?
    let img: String?
    
    init(name: String, cost: Int, attack: Int, health: Int, text: String, img: String) {
        self.name = name
        self.cost = cost
        self.attack = attack
        self.health = health
        self.text = text
        self.img = img
    }
    
    init(cardData: [String: Any]) {
        self.name = cardData["name"] as? String ?? ""
        self.cost = cardData["cost"] as? Int ?? 0
        self.attack = cardData["attack"] as? Int ?? 0
        self.health = cardData["health"] as? Int
        self.text = cardData["text"] as? String
        self.img = cardData["img"] as? String
    }
    
}
