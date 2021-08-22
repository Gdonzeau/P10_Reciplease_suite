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
    private init() {}
    func getRecipes (ingredients: String, completion: @escaping (Result<RecipeResponse,AFError>)->Void) { //completio type result
        
        let adressUrl = Settings.urlAdress // A mettre dans un fichier config
        
        let parameters = ["app_id": Keys.id.rawValue,
                          "app_key":Keys.key.rawValue,
                          "from":"1", // À tester... et à passer ensuite en Config si ça marche
                          "to": String(Settings.quantityOfAnswers),
                          "q": ingredients]
        Session.default.request(adressUrl, parameters: parameters)
            .validate() //requête et valide que la réponse est valide (200, pas d'erreur, etc.)
            .responseDecodable(of: RecipeResponse.self) { (response) in
                completion(response.result)
            }
    }
}

final class AuthenticationAPI {
    func getRecipes (ingredients: String, completion: @escaping (Result<RecipeResponse,AFError>)->Void) {
    //func login(username: String, password: String, completion: @escaping (DefaultDataResponse) -> Void) {
        let parameters = ["app_id": Keys.id.rawValue,
                          "app_key":Keys.key.rawValue,
                          "from":"1", // À tester... et à passer ensuite en Config si ça marche
                          "to": String(Settings.quantityOfAnswers),
                          "q": ingredients]
        let adressUrl = Settings.urlAdress // A mettre dans un fichier config
        
        //Alamofire.request("https://example.com/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        Session.default.request(adressUrl, parameters: parameters)
            .validate() // Ou pas ?
            /*
            .response { (response) in
                // hande response
            }
 */
            .responseDecodable(of: RecipeResponse.self) { (response) in
                completion(response.result)
            }
    }
}

final class AuthenticationAPIBis {
    
    //private let manager: SessionManager
    private let otherManager : Session
    init(manager: Session = Session.default) {
    //init(manager: SessionManager = SessionManager.default) {
        self.otherManager = manager
    }
    func getRecipes (ingredients: String, completion: @escaping (Result<RecipeResponse,AFError>)->Void) {
    //func login(username: String, password: String, completion: @escaping (DefaultDataResponse) -> Void) {
        let parameters = ["app_id": Keys.id.rawValue,
                          "app_key":Keys.key.rawValue,
                          "from":"1", // À tester... et à passer ensuite en Config si ça marche
                          "to": String(Settings.quantityOfAnswers),
                          "q": ingredients]
        let adressUrl = Settings.urlAdress // A mettre dans un fichier config
        
        //let parameters: Parameters = ["username": username, "password": password]
        
        //otherManager.request("https://example.com/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        otherManager.request(adressUrl, parameters: parameters)
            .validate() // Ou pas ?
            /*
            .response { (response) in
                // Handle repsonse
            }
 */
            .responseDecodable(of: RecipeResponse.self) { (response) in
                completion(response.result)
            }
    }
}
