//
//  ResultViewController.swift
//  RecipEasy
//
//  Created by Owen Smith on 2020-02-02.
//  Copyright © 2020 Owen Smith. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var recipes: [RecipeData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //print(recipes)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func RescanPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //clearTable()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recipes?.count ?? 0)
        return (recipes?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        cell.setRecipe(recipe: recipe!)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    
}
