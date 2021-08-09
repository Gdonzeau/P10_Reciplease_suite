//
//  RecipesReceived.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 13/07/2021.
//

import Foundation
/*
struct RecipesReceived {
    var recipesReceived:[Recette]
}
*/
/*
 "hits": [
         {
             "recipe": {
                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_f285a9024489ce7a34573a6a83fe5c17",
                 "label": "Herbed Chicken & Tomatoes recipes",
                 "image": "https://www.edamam.com/web-img/7aa/7aa9a0006423f523e3064b055d4a09e0",
                 "source": "Epicurious",
                 "url": "http://www.epicurious.com/recipes/food/views/herbed-chicken-tomatoes-56390044",
                 "shareAs": "http://www.edamam.com/recipe/herbed-chicken-tomatoes-recipes-f285a9024489ce7a34573a6a83fe5c17/chicken+tomatoes",
                 
                 "ingredientLines": [
                     "8 ounces pasta, such as spaghetti or linguine",
                     "1 1/2 teaspoons McCormick Gourmet™ Basil",
                     "1 1/2 teaspoons McCormick Gourmet™ Garlic Powder, California",
                     "1 teaspoon McCormick Gourmet™ Rosemary, Crushed",
                     "3 tablespoons flour, divided",
                     "1 1/2 pounds thin-sliced boneless skinless chicken breasts",
                     "2 to 3 tablespoons vegetable oil, divided",
                     "1 small onion, finely chopped",
                     "1 can (14 1/2 ounces) petite diced tomatoes, drained",
                     "1 1/2 cups Kitchen Basics® Unsalted Chicken Stock",
                     "2 tablespoons fat free half-and-half"
                 ],
                 "ingredients": [
                     {
 */
struct RecipeResponse: Decodable {
    let recipes: [Recipe]

    enum CodingKeys: String, CodingKey {
        case recipes = "hits"
    }
}
struct Recipe {
    let name: String
    let imageURL: String?
    let url: String?
    let numberOfPeople: Float
    let duration: Float
    let ingredientsNeeded: [String]
    
    // Je sais, pas de ! mais là, c'est pour tester
    init(from recipeEntity: RecipeStored) {
        
        self.name = recipeEntity.name ?? "No name"
        self.imageURL = recipeEntity.imageUrl ?? "No adress image"
        self.url = recipeEntity.url ?? "No url"
        self.numberOfPeople = recipeEntity.person
        self.duration = recipeEntity.totalTime
        self.ingredientsNeeded = recipeEntity.ingredients ?? []
    }
    
 
}

extension Recipe: Codable {
    
    enum BlaBla: String, CodingKey {
        case recipe
        case name = "label"
        case imageURL = "image"
        case url
        case numberOfPeople = "yield"
        case duration = "totalTime"
        case ingredientsNeeded = "ingredientLines"

        case totalDaily
        case ENERC_KCAL
        case quantity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BlaBla.self)

        let recipe = try container.nestedContainer(keyedBy: BlaBla.self, forKey: .recipe)

        name = try recipe.decode(String.self, forKey: .name)
        imageURL = try recipe.decode(String.self, forKey: .imageURL)
        url = try recipe.decode(String.self, forKey: .url)
        numberOfPeople = try recipe.decode(Float.self, forKey: .numberOfPeople)
        duration = try recipe.decode(Float.self, forKey: .duration)
        ingredientsNeeded = try recipe.decode([String].self, forKey: .ingredientsNeeded)



        let totalDaily = try recipe.nestedContainer(keyedBy: BlaBla.self, forKey: .totalDaily)
        let energetic = try totalDaily.decode(MyObject.self, forKey: .ENERC_KCAL)
        //try totalDaily.nestedContainer(keyedBy: BlaBla.self, forKey: .ENERC_KCAL)
        //let quantity = try energetic.decode(Float.self, forKey: .quantity)
        
    }
}

struct MyObject: Decodable {
    let label: String
    let quantity: Float
    let unit: String
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url // if var(de type Recipe) == var(
    }
}
/*
struct RecipeReceived: Codable {
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes = "hits"
    }
}

struct Recipe: Codable {
    var name: String // label selon l'API
    var imageURL: String
    var url: String
    var ingredientsNeeded: [String]
    var totalTime: Float
    var numberOfPeople: Float
    
    enum CodingKeys: String, CodingKey {
        case recipe
        case name = "label"
        case imageURL = "image"
        case ingredientsNeeded = "indredientLines"
        case totalTime
        case numberOfPeople = "yield"
        case url
        
        case totalDaily
        case ENERC_KCAL
        case quantity
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recipe = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recipe)

        name = try recipe.decode(String.self, forKey: .name)
        imageURL = try recipe.decode(String.self, forKey: .imageURL)
        url = try recipe.decode(String.self, forKey: .url)
        numberOfPeople = try recipe.decode(Float.self, forKey: .numberOfPeople)
        totalTime = try recipe.decode(Float.self, forKey: .totalTime)
        ingredientsNeeded = try recipe.decode([String].self, forKey: .ingredientsNeeded)



        let totalDaily = try recipe.nestedContainer(keyedBy: CodingKeys.self, forKey: .totalDaily)
        let energetic = try totalDaily.decode(MyObject.self, forKey: .ENERC_KCAL)
        
    }
    /*
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recipe, forKey: .recipe)
    }
    */
}
struct MyObject: Decodable {
    let label: String
    let quantity: Float
    let unit: String
}

struct Energy: Codable {
    var totalDaily: Float
    var ENERC_KCAL: Float
    var quantity: Float
}
*/

/*
extension RecipeReceived: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .additionnalInfo)
    }
}
*/

// Fichier Othmane :
/*
 let jsonString = """

 """
 let jsonData = jsonString.data(using: .utf8)




 // MARK: -

 let decoder = JSONDecoder()
 //decoder.keyDecodingStrategy = .convertFromSnakeCase
 //decoder.dateDecodingStrategy = .secondsSince1970
 //let object = try decoder.decode(Launch.self, from: jsonData!)
 */
