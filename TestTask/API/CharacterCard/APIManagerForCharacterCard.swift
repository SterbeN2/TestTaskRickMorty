//
//  APIManagerForCharacterCard.swift
//  TestTask
//
//  Created by Ильнур Загитов on 02.03.2023.
//

import UIKit

class APIManagerForCharacterCard {
    
    static let shared = APIManagerForCharacterCard()

    func loadImage(id: Int, complition: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlString + "\(id)")! // force unwrap!
        var request = URLRequest(url: url) // let
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in // можно: "[weak self] data, _, _"
            guard let data else {return}
            if let someCharacter = try? JSONDecoder().decode(CharacterCardData.self, from: data) { // guard
                self?.loadImageContent(url: someCharacter.url, complition: complition)
            }
        }
        task.resume()
    }
    
    func loadImageContent(url: String, complition: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, error in // force unwrap
            if let data, let image = UIImage(data: data) { // guard
                complition(image)
            } else {
                complition(nil)
            }
        }
        task.resume()
    }
    
    func getInfoAboutCharacter(id: Int, complition: @escaping (CharacterCardData) -> ()) {
        let url = URL(string: urlString + "\(id)")! // force unwrap
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {return}
            if let infoAboutCharacter = try? JSONDecoder().decode(CharacterCardData.self, from: data) { // guard
                complition(infoAboutCharacter)
                print(infoAboutCharacter)
            } else {
                print("Failure to get character information")
            }
        }
        task.resume()
    }
    
    
    //MARK: - Private constatns
    private let urlString = "https://rickandmortyapi.com/api/character/" // название не говорящее
}
