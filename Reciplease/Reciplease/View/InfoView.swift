//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoView: UIView {
    @IBOutlet weak var name: UILabel!
    /*
    var recipe: Recipe? {
        didSet {
            configureView()
        }
    }
    */
    
    var recipe: Recipe? //{
        /*
        didSet {
            if let timeToPrepare = recipe?.duration, let person = recipe?.numberOfPeople {
                configureInfo(timeToPrepare: String(timeToPrepare), person: Int(person))
            }
        }
        */
    //}
 
    var timeToCook: String = "" {
        didSet {
            if let timeToPrepare = recipe?.duration {
                timeToCook = String(timeToPrepare)
                configureInfo(timeToPrepare: timeToCook, person: person)
            }
        }
    }
    
    var person: Int = 0 {
        didSet {
            if let numberOfPersons = recipe?.numberOfPeople {
                person = Int(numberOfPersons)
                configureInfo(timeToPrepare: timeToCook, person: person)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
    }
    
    private func configureInfo(timeToPrepare: String, person: Int) {
        //let timeToPrepare = ""
        //let person = 0
        //
        let preparationTime = UILabel()
        preparationTime.textAlignment = .center
        preparationTime.translatesAutoresizingMaskIntoConstraints = false //Utilise autolayout
        preparationTime.text = timeToPrepare
        
        let howManyPerson = UILabel()
        howManyPerson.textAlignment = .center
        howManyPerson.translatesAutoresizingMaskIntoConstraints = false
        howManyPerson.text = " : \(String(person))"
    }
}
