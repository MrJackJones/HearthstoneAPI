//
//  Card.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import Foundation

struct Card: Codable {
    let name: String
    let cost: Int
    let attack: Int
    let health: Int?
    let text: String?
    let img: String?
}
