//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by ROHIT GUPTA on 11/5/16.
//  Copyright © 2016 ROHIT GUPTA. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
