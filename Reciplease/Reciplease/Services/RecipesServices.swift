//
//  GetRecipes.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 09/07/2021.
//

import Foundation
import Alamofire

class RecipesServices {
    static var shared = RecipesServices()
    private let session: Session
    init(session: Session = .default) {
        self.session = session
    }
    func getRecipes (ingredients: String, completion: @escaping (Result<RecipeResponse,AFError>)->Void) { //completio type result
        
        let adressUrl = Settings.urlAdress
        
        let parameters = ["app_id": Keys.id.rawValue,
                          "app_key":Keys.key.rawValue,
                          "from":"1", // À tester... et à passer ensuite en Config si ça marche
                          "to": String(Settings.quantityOfAnswers),
                          "q": ingredients]
        session.request(adressUrl, parameters: parameters)
            .validate() //requête et valide que la réponse est valide (200, pas d'erreur, etc.)
            .responseDecodable(of: RecipeResponse.self) { (response) in
                completion(response.result)
            }
    }
}
