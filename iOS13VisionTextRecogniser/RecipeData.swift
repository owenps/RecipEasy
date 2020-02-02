//
//  RecipeData.swift
//  RecipEasy
//
//  Created by Owen Smith on 2020-02-02.
//  Copyright © 2020 Owen Smith. All rights reserved.
//

import Foundation

struct RecipeData: Decodable{ 
    let title: String
    let image: String
    let usedIngredients: [UsedIngredients]
    let missedIngredients: [MissedIngredients]
}

struct UsedIngredients: Decodable{
    let name: String
}

struct MissedIngredients: Decodable{
    let name: String
}
