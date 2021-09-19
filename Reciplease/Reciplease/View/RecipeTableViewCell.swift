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
        
        // Convert time into adapted format
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.hour, .minute]
        
        guard let timeForPrepare = Double(timeToPrepare) else {
            return
        }
        guard let time = formatter.string(from: Double(timeForPrepare)*60) else {
            return
        }
        // If time or person = 0, no need to show these infos
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
        
        // Sendind infos by dependance injection
        stackViewInfo.codeInfoTimeView.title.text = " : \(time) "
        stackViewInfo.codeInfoPersonView.title.text = " : \(String(Int(person))) pers. "
        
        
        recipeName.text = "  " + name
        recipeName.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
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
}
