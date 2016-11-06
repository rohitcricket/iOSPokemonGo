//
//  CoreDataHelp.swift
//  PokemonGoClone
//
//  Created by ROHIT GUPTA on 11/5/16.
//  Copyright © 2016 ROHIT GUPTA. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon(){
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Pokedex", imageName: "pokedex")
    createPokemon(name: "Heart", imageName: "heart")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Pokeball", imageName: "pokeball")
    createPokemon(name: "Potion", imageName: "potion")
    createPokemon(name: "Zubat", imageName: "zubat")
    createPokemon(name: "LuckyEgg", imageName: "lucky-egg")
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, imageName: String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

