//
//  RecipeManager.swift
//  RecipEasy
//
//  Created by Owen Smith on 2020-02-02.
//  Copyright © 2020 Owen Smith. All rights reserved.
//

import Foundation

protocol RecipeManagerDelegate {
    func didUpdateRecipes(recipes: [RecipeData])
}

struct RecipeManager {
    let recipeURL = "https://api.spoonacular.com/recipes/findByIngredients?&apiKey=aa272aea32284c36a2153f570f94cd3a&ranking=1"
    
    var delegate:RecipeManagerDelegate?
    
    func fetchIngredient(ingreds: String){
        let formattedIngreds = reFormatString(str: ingreds)
        let urlString = "\(recipeURL)&ingredients=\(formattedIngreds)"
        performRequest(urlString: urlString)
    }
    
    func reFormatString(str: String) -> String{
        var newStr = ""
        for char in str{
            if char == "\n" {
                newStr += ",+"
            }else{
                newStr += String(char)
            }
        }
        newStr = String(newStr.dropLast(2)) //last two characters are +, which do not need to be included
        return newStr
    }
    
    func performRequest(urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data,response,error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let recipes = self.parseJSON(recipeData: safeData) {
                        self.delegate?.didUpdateRecipes(recipes:recipes)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(recipeData: Data) -> [RecipeData]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([RecipeData].self, from: recipeData) 
            //print(decodedData[1].usedIngredients[0])
            return decodedData
        }catch {
            print(error)
            return nil
        }
        
    }
    
}
