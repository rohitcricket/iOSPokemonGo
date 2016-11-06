//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by ROHIT GUPTA on 11/6/16.
//  Copyright © 2016 ROHIT GUPTA. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon : Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
