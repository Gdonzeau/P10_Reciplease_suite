//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoView: UIView {
    @IBOutlet weak var name: UILabel!
    
    var recipe: Recipe? {
        didSet {
            configureView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
        // Initialization code
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func configureView() {
        // Paramètres de configureView mais marche pas
        name.text = "OK"
        let timeToPrepare = ""
        let person = 0
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
