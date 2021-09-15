//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoView: UIView {
    var name = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .white
        
        setupView()
        //setupConstraints()
        //setupLikeButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(title)
    }
 
    let title: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 31))
        let text = "Bonjour"
        title.text = text
        return title
    }()
    /*
    var recipe: Recipe? {
        
        didSet {
            informationLoading()
            print("Bouh")
            if let timeToPrepare = recipe?.duration, let person = recipe?.numberOfPeople {
                //print("Recette : \(timeToPrepare) \(person)")
                configureInfo(timeToPrepare: String(timeToPrepare), person: Int(person))
            }
        }
    }
 
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
        //configureInfo(timeToPrepare: timeToCook, person: person)
        backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
    }
    
    func configureInfo(timeToPrepare: String, person: Int) {
        //let timeToPrepare = ""
        //let person = 0
        //
        
        let preparationTime = UILabel()
        preparationTime.textAlignment = .center
        preparationTime.translatesAutoresizingMaskIntoConstraints = false //Utilise autolayout
        preparationTime.text = timeToPrepare
        //name.text = timeToPrepare
        /*
        let howManyPerson = UILabel()
        howManyPerson.textAlignment = .center
        howManyPerson.translatesAutoresizingMaskIntoConstraints = false
        howManyPerson.text = " : \(String(person))"
        NSLayoutConstraint.activate([
            preparationTime.leadingAnchor.constraint(equalTo: leadingAnchor), // left side
            preparationTime.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 2.0)
        ])
        */
    }
    
    func informationLoading() {
        
    }
    
    func calculateTime() {
        guard let timeToPrepare = recipe?.duration else {
            //SVTiming.isHidden = true
            return
        }
        //SVTiming.isHidden = false
        let interval: TimeInterval = Double(timeToPrepare)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        //if interval >= 60 {
        formatter.allowedUnits = [.hour, .minute]
        //} else {
        //    formatter.allowedUnits = [.minute]
        //}
        
        
        var time = formatter.string(from: Double(timeToPrepare*60))
        /*
        if interval >= 60 {
            time = time + " h"
        } else {
        time = time + " m"
        }
        */
        
        /*
        if time == "0 m" {
            SVTiming.isHidden = true
        } else {
            SVTiming.isHidden = false
        }
        if person == 0 {
            SVHowManyPerson.isHidden = true
        } else {
            SVHowManyPerson.isHidden = false
        }
        */
        
    }
 */
}
