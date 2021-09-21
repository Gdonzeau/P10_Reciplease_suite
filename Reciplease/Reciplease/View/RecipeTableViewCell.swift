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
            configure()
            
            if let timeToPrepare = recipe?.duration, let name = recipe?.name, let person = recipe?.numberOfPeople, let image = recipe?.imageURL {
            configure(timeToPrepare: String(timeToPrepare), name: name, person: person, image: image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    private func configure() {
        stackViewInfo.duration = recipe?.duration
    }
    
    private func configure(timeToPrepare: String, name: String, person: Float, image: String) {
        let backGroundImage = UIImageView()
        guard let urlImage = URL(string: image) else {
            return
        }
        backGroundImage.load(url: urlImage)
        backgroundView = backGroundImage
        backgroundView?.contentMode = .scaleAspectFill
        
        addSubview(stackViewInfo)
        
        trailingAnchor.constraint(equalTo: stackViewInfo.trailingAnchor).isActive = true
        stackViewInfo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        stackViewInfo.duration = recipe?.duration
        stackViewInfo.persons = recipe?.numberOfPeople
        
        recipeName.text = "  " + name
        recipeName.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
}
