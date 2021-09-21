//
//  NetworkErrors.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 06/07/2021.
//

import Foundation
// Different potential errors
//AppErrors
enum AppError: String, LocalizedError {
    case loadingError = "Loading Error."
    case coreDataError = "CoreData Error."
    case errorDelete = "Error while deleting"
    case errorSaving = "Error while saving"
    case nothingIsWritten = "You must write something correct"
    case noUrl = "No url adress"
    case noImage = "No Image"
    
    var errorDescription: String? {
        switch self {
        case .coreDataError:
            return "Problème CoreData"
        case .errorDelete:
            return "Problem occured while deleting"
        case .errorSaving:
            return "Problem occured while saving"
        case .nothingIsWritten:
            return "You must write something."
        case .noUrl:
            return "There is no url adress for this recipe"
        case .noImage:
            return "There are no image associated with this recipe"
        case .loadingError:
            return "There was an loading error"
        }
    }
    var failureReason: String? {
        switch self {
        case .coreDataError:
            return "Erreur CoreData"
        case .errorDelete:
            return "Did not delete"
        case .errorSaving:
            return "Did not save"
        case .nothingIsWritten:
            return "No ingredient"
        case .noUrl:
            return "No url adress"
        case .noImage:
            return "No image associated"
        case .loadingError:
            return "Loading Error"
        }
    }
}

