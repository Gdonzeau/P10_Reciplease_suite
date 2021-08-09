//
//  NetworkErrors.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 06/07/2021.
//

import Foundation
// Different potential errors
enum APIErrors: String, LocalizedError {
    
    case noData = "No data"
    case noError = "There is no error." // For tests
    case decodingError = "Decoding Error."
    case invalidURL = "Not the right adress."
    case invalidStatusCode = "Status invalid"
    case errorGenerated = "Error generated"
    case nothingIsWritten = "You must write something correct"
    case ingredientUnknown = "Ingredient Unknown"
    case noUrl = "No url adress"
    case noImage = "No Image"
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Aucune donnée n'est renvoyée."
        case .noError:
            return "Tout va bien, pas d'erreur."
        case .decodingError:
            return "Le fichier renvoyé est endommagé."
        case .invalidURL:
            return "L'adresse internet est non conforme."
        case .invalidStatusCode:
            return "Le statut est invalide."
        case .errorGenerated:
            return "Erreur au moment de la requête réseau."
        case .nothingIsWritten:
            return "You must write something."
        case .ingredientUnknown:
            return "There is at least one ingredient unknown"
        case .noUrl:
            return "There is no url adress for this recipe"
        case .noImage:
            return "There are no image associated with this recipe"
        }
    }
    var failureReason: String? {
        switch self {
        case .noData:
            return "Pas de données"
        case .noError:
            return "Pas d'erreur"
        case .decodingError:
            return "Erreur au décodage"
        case .invalidURL:
            return "Mauvaise adresse"
        case .invalidStatusCode:
            return "Statut invalide"
        case .errorGenerated:
            return "Erreur requête réseau"
        case .nothingIsWritten:
            return "No ingredient"
        case .ingredientUnknown:
            return "Ingredient unknown"
        case .noUrl:
            return "No url adress"
        case .noImage:
            return "No image associated"
        }
    }
}
