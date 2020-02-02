//
//  RecipeCell.swift
//  RecipEasy
//
//  Created by Owen Smith on 2020-02-02.
//  Copyright © 2020 Anupam Chugh. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {


    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeUsedLabel: UILabel!
    @IBOutlet weak var recipeMissingLabel: UILabel!
    
    
    func setRecipe(recipe:RecipeData){
        recipeImageView.image = recipe.image.toImage()
        recipeTitleLabel.text = recipe.title
        recipeUsedLabel.text = String(recipe.usedIngredients.count)
        recipeMissingLabel.text = String(recipe.missedIngredients.count)
    }
    
}

extension String{
    func toImage() -> UIImage? {
        let imageUrl = URL(string: self)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data:imageData)
        return image
    }
}
