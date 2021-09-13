//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    private var codeInfoView = InfoView()

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var SVTiming: UIStackView!
    @IBOutlet weak var howManyPerson: UILabel!
    @IBOutlet weak var SVHowManyPerson: UIStackView!
    @IBOutlet weak var informations: InfoView!
    
    
    
     //Ajouter didSet
    //setUpInfoView()
    var recipe: Recipe? {
        
        didSet {
            if let timeToPrepare = recipe?.duration, let name = recipe?.name, let person = recipe?.numberOfPeople, let image = recipe?.imageURL {
            configure(timeToPrepare: String(timeToPrepare), name: name, person: person, image: image)
            }
            if let infoName = recipe?.name {
                print(infoName)
               // information2.name.text = infoName
            }
            setUpInfoView()
            /*
            if let image = recipe.imageUrl {
                
                if let url = URL(string: image) {
               // imageBackgroundCell.load(url: url)
                }
            }
            */
            
            //recipeName.text = recipe?.name
            //recipeName.font(.custom("OpenSans-Bold", size: 34))
            //timing.text = String(recipe.totalTime)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        //setUpInfoView()
        
        // Initialization code
    }
    /*
    private func configure() {
        // copier coller plus bas
    }
    */
    private func addShadow() {
        // Pas d'ombre finalement
    }
    
    private func setUpInfoView() {
        codeInfoView.translatesAutoresizingMaskIntoConstraints = false
        codeInfoView.backgroundColor = .red
        codeInfoView = InfoView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        codeInfoView.configureInfo(timeToPrepare: "Hello", person: 0)
        self.addSubview(codeInfoView)
        
        
        
    }
    private func configure(timeToPrepare: String, name: String, person: Float, image: String) {
        let backGroundImage = UIImageView()
        guard let urlImage = URL(string: image) else {
            return
        }
        backGroundImage.load(url: urlImage)
        backgroundView = backGroundImage
        backgroundView?.contentMode = .scaleAspectFill
        
        
        let interval: TimeInterval = Double(timeToPrepare) ?? 0
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        //if interval >= 60 {
        formatter.allowedUnits = [.hour, .minute]
        //} else {
        //    formatter.allowedUnits = [.minute]
        //}
        
        /*
        guard var time = formatter.string(from: Double(timeToPrepare*60)) else {
            return
        }
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
        recipeName.text = "  " + name
        recipeName.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //recipeName.font(.custom("OpenSans-Bold", size: 34))
        timing.text = " : \(time)"
        howManyPerson.text = " : \(String(Int(person))) pers."
        
        //information2.name.text = " : \(String(Int(person))) pers."
        
        SVTiming.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        SVHowManyPerson.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
}
/*
// Because of : 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release
extension RecipeTableViewCell: NSSecureCoding {
    static var supportsSecureCoding = true
}
*/
