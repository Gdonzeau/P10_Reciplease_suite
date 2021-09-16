//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    //private var codeInfoTimeView = InfoTimeView()
    //private var codeInfoPersonView = InfoPersonView()
    private var stackViewInfo = StackViewInfo()

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var SVTiming: UIStackView!
    @IBOutlet weak var howManyPerson: UILabel!
    @IBOutlet weak var SVHowManyPerson: UIStackView!
    @IBOutlet weak var informations: InfoTimeView!
    
    
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
            //setUpInfoView()
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
        //codeInfoTimeView.translatesAutoresizingMaskIntoConstraints = false
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackViewInfo)
        stackViewInfo.frame(forAlignmentRect: CGRect(x: 50, y: 0, width: 30, height: 30))
        //stackViewInfo.addSubview(codeInfoTimeView)
        //stackViewInfo.addSubview(codeInfoPersonView)
        
        
        
        
    }
    private func configure(timeToPrepare: String, name: String, person: Float, image: String) {
        let backGroundImage = UIImageView()
        guard let urlImage = URL(string: image) else {
            return
        }
        backGroundImage.load(url: urlImage)
        backgroundView = backGroundImage
        backgroundView?.contentMode = .scaleAspectFill
        
        setUpInfoView()
        
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
        
        /*
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 21, weight:.light)
        let imageToAdd = UIImage(systemName: "clock", withConfiguration: imageSymbolConfiguration)
        */
        /*
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "xmark.circle")

        let imageString = NSMutableAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: "Please try again")
        imageString.append(textString)
 */
/*
        let label = UILabel()
        label.attributedText = imageString
        label.sizeToFit()
  */
        
        
        //stackViewInfo.codeInfoTimeView.title.attributedText = textString
        //stackViewInfo.codeInfoTimeView.title.sizeToFit()
        stackViewInfo.codeInfoTimeView.title.text = " : \(time)"
        stackViewInfo.codeInfoPersonView.title.text = " : \(String(Int(person))) pers."
        
        
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
