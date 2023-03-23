//
//  APIManagerCharaterData.swift
//  TestTask
//
//  Created by Ильнур Загитов on 28.02.2023.
//

import Foundation

class APIManagerCharaterData {
    static let shared = APIManagerCharaterData()
    
    func getListOfCharacters (completion: @escaping ([Result]) -> Void) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {return}
            if let characterData = try? JSONDecoder().decode(PersonData.self, from: data){
                completion(characterData.results)
//                print(characterData.results)
            } else {
                print("fail")
            }
        }
        task.resume()
    }
    
    
    
    
    //MARK: - Private constatns
    private let urlString = "https://rickandmortyapi.com/api/character/?page=2"
    
}
