//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    private var stackViewInfo = StackViewInfo()

    @IBOutlet weak var recipeName: UILabel!
    
    var recipe: Recipe? {
        
        didSet {
            if let timeToPrepare = recipe?.duration, let name = recipe?.name, let person = recipe?.numberOfPeople, let image = recipe?.imageURL {
            configure(timeToPrepare: String(timeToPrepare), name: name, person: person, image: image)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupInfoView() {
        self.addSubview(stackViewInfo)
    }
    
    private func setupConstraintsInfoView() {
        //stackViewInfo.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stackViewInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        stackViewInfo.bottomAnchor.constraint(equalTo: recipeName.topAnchor, constant: 0).isActive = true
        //stackViewInfo.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        //self.trailingAnchor.constraint(equalTo: stackViewInfo.trailingAnchor, constant: 0).isActive = true
        
    }
    private func configure(timeToPrepare: String, name: String, person: Float, image: String) {
        let backGroundImage = UIImageView()
        guard let urlImage = URL(string: image) else {
            return
        }
        backGroundImage.load(url: urlImage)
        backgroundView = backGroundImage
        backgroundView?.contentMode = .scaleAspectFill
        
        setupInfoView()
        setupConstraintsInfoView()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        //if interval >= 60 {
        formatter.allowedUnits = [.hour, .minute]
        
        guard let timeForPrepare = Double(timeToPrepare) else {
            return
        }
        guard let time = formatter.string(from: Double(timeForPrepare)*60) else {
            return
        }
        
        if time == "0min" {
            stackViewInfo.codeInfoTimeView.isHidden = true
        } else {
            stackViewInfo.codeInfoTimeView.isHidden = false
        }
        if person == 0 {
            stackViewInfo.codeInfoPersonView.isHidden = true
        } else {
            stackViewInfo.codeInfoPersonView.isHidden = false
        }
        print("Envoi : \(time)")
        
        stackViewInfo.codeInfoTimeView.title.text = " : \(time) "
        stackViewInfo.codeInfoPersonView.title.text = " : \(String(Int(person))) pers. "
        
        
        recipeName.text = "  " + name
        recipeName.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //recipeName.font(.custom("OpenSans-Bold", size: 34))
        //timing.text = " : \(time)"
        //howManyPerson.text = " : \(String(Int(person))) pers."
        
        //information2.name.text = " : \(String(Int(person))) pers."
        
        //SVTiming.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //SVHowManyPerson.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
}
/*
// Because of : 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release
extension RecipeTableViewCell: NSSecureCoding {
    static var supportsSecureCoding = true
}
*/
