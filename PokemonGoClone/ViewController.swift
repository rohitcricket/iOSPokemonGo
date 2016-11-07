//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by ROHIT GUPTA on 10/25/16.
//  Copyright © 2016 ROHIT GUPTA. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // spawn pokemon
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                anno.coordinate = coord
                let randomLat = (Double(arc4random_uniform(200)) - 100)/50000.0
                let randomLon = (Double(arc4random_uniform(200)) - 100)/50000.0
                anno.coordinate.latitude += randomLat
                anno.coordinate.longitude += randomLon
                
                self.mapView.addAnnotation(anno)
            }
            
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            return annoView
        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(Timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokemon.name!). You are a Pokeman Jedi!", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    })
                    alertVC.addAction(OKaction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                } else {
                    let alertVC = UIAlertController(title: "Uh-oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                    })
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
            }
        })
        


        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }

    }
    
    func getAllPokemon() -> [Pokemon] {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                addAllPokemon()
                return getAllPokemon()
            }
            return pokemons
        } catch {
            
        }

        return []
    }
    
    func getAllCaughtPokemons() -> [Pokemon] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
        
        do {
            let pokemons = try context.fetch(fetchRequest)
            return pokemons
        } catch {}
        return []
    }
    
    func getAllUncaughtPokemons() -> [Pokemon] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
        
        do {
            let pokemons = try context.fetch(fetchRequest) 
            return pokemons
        } catch {}
        return []
    }
    

}

