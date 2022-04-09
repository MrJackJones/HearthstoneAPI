//
//  NetworkManager.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import Foundation
import UIKit

class NetworkManager {    
    static func getCards(completion: @escaping ([Card]) -> Void) {
        guard let fullURL = URL(string: "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/types/Minion?locale=ruRU") else {return}
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-RapidAPI-Host": "omgvamp-hearthstone-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "edbcd4362emshbfd5f4b1ffda8f1p185d96jsnd269f3d63e73"
        ]
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error request \(error)")
                return
            }
            guard let data = data else {
                print("Error data")
                return
            }
            
            do {
                let cards = try JSONDecoder().decode([Card].self, from: data)
                DispatchQueue.main.async {
                    completion(cards.filter({ $0.img != nil }))
                }
            } catch let error {
                print("Error decode data \(error)")
            }

        }.resume()
    }
    
    static func getImage(imageUrl: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: imageUrl) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error request \(error)")
                return
            }
            guard let data = data else {
                print("Error data")
                return
            }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {return}
                completion(image)
            }

        }.resume()
    }
    
    private init() {}
}
