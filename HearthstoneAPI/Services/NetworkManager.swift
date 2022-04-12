//
//  NetworkManager.swift
//  HearthstoneAPI
//
//  Created by Ivan on 09.04.2022.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum URLs: String {
    case apiURL = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/types/Minion?locale=enUS"
}

enum Credentials: String {
    case apiHost = "omgvamp-hearthstone-v1.p.rapidapi.com"
    case apiKey = "edbcd4362emshbfd5f4b1ffda8f1p185d96jsnd269f3d63e73"
}


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func fetchCards(completion: @escaping (Result<[Card], NetworkError>) -> Void) {
        guard let fullURL = URL(string: URLs.apiURL.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-RapidAPI-Host": Credentials.apiHost.rawValue,
            "X-RapidAPI-Key": Credentials.apiKey.rawValue
        ]
        
        URLSession.shared.dataTask(with: request) { data, _,_ in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let cards = try JSONDecoder().decode([Card].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(cards.filter({ $0.img != nil })))
                }
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    func fetchImage(imageUrl: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: imageUrl) else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
            
        }.resume()
    }
    
    
    func fetchAlamofireCards(completion: @escaping (Result<[Card], NetworkError>) -> Void) {
        var cards: [Card] = []
        AF.request(URLs.apiURL.rawValue,
                   headers: [
                    "X-RapidAPI-Host": Credentials.apiHost.rawValue,
                    "X-RapidAPI-Key": Credentials.apiKey.rawValue
                   ])
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let cardsData = value as? [[String: Any]] else {return}
                    for cardData in cardsData {
                        if let _ = cardData["img"] {
                            cards.append(Card.init(cardData: cardData))
                        }
                    }
                    completion(.success(cards))
                case .failure(_):
                    completion(.failure(.noData))
                }
                
            }
    }
    
    func fetchAlamofireImage(imageUrl: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(imageUrl)
            .validate()
            .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.noData))
            }
            
        })
    }
}
