//
//  CharacterCardData.swift
//  TestTask
//
//  Created by Ильнур Загитов on 02.03.2023.
//

import Foundation

// MARK: - CharacterCardData
struct CharacterCardData: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Locations: Codable {
    let name: String
    let url: String
}
