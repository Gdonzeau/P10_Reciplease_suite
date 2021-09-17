//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoTimeView: UIView {
    
    var timeToPrepare = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupView()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.addSubview(title)
        self.addSubview(symbolTime)
        backgroundColor = .white
        //self.addSubview(symbolTest)
    }
    
    let title: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 31))
        let title2 = UILabel()
        title2.translatesAutoresizingMaskIntoConstraints = false
        var text = "" {
            didSet {
                title2.text = text
            }
        }
        return title2
    }()
    /*
    let stackView: UIStackView = {
       let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 40, height: 31))
        stack.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
    return stack
    }()
    */
    let symbolTime: UIImageView = {
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 21, weight:.light)
        let imageToAdd = UIImage(systemName: "clock", withConfiguration: imageSymbolConfiguration)
        let width = imageToAdd?.size.width
        let height = imageToAdd?.size.height
        
        //var image = UIImageView(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image = UIImageView(image: imageToAdd)
        image.tintColor = UIColor.white

        return image
    }()
    
    func setupConstraints() {
        let constraints = [
            /*
            //symbolTime.topAnchor.constraint(equalTo: superview!.topAnchor),
            //symbolTime.leadingAnchor.constraint(equalTo: superview!.leadingAnchor),
            symbolTime.heightAnchor.constraint(equalToConstant: 31),
            symbolTime.widthAnchor.constraint(equalToConstant: 31),
            
            //title.topAnchor.constraint(equalTo: superview!.topAnchor),
            title.leadingAnchor.constraint(equalTo: symbolTime.rightAnchor, constant: -10),
            title.heightAnchor.constraint(equalToConstant: 31),
            title.widthAnchor.constraint(equalToConstant: 120)
            */
            
            title.topAnchor.constraint(equalTo: symbolTime.topAnchor),
            title.leftAnchor.constraint(equalTo: symbolTime.leftAnchor, constant: -40),
            title.bottomAnchor.constraint(equalTo: symbolTime.bottomAnchor),
            title.rightAnchor.constraint(equalTo: symbolTime.rightAnchor, constant: 40)
            
            
            
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    /*
    func setupContraintsTest() {
        let constraints = [
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 100),
            view.heightAnchor.constraint(equalTo: view.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let constraints2 = [
            innerSquare.topAnchor.constraint(equalTo: outerSquare.topAnchor),
            innerSquare.leftAnchor.constraint(equalTo: outerSquare.leftAnchor, constant: 40),
            outerSquare.bottomAnchor.constraint(equalTo: innerSquare.bottomAnchor),
            outerSquare.rightAnchor.constraint(equalTo: innerSquare.rightAnchor, constant: 40)
        ]

        NSLayoutConstraint.activate(constraints2)
    }
    */
    
    
    /*
    let symbolTest: UIButton = {
     //let imageClock = UIImage(systemName: "clock")//
     
     let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 31, weight: .black)
     let homeImage = UIImage(systemName: "clock", withConfiguration: homeSymbolConfiguration)
     let width = homeImage?.size.width
     let height = homeImage?.size.height
     let homeButton = UIButton(frame: CGRect(x: 20, y: 20, width: width!, height: height!))
     homeButton.tintColor = UIColor.gray
     homeButton.setImage(homeImage, for: .normal)
        return homeButton
    }()
 */
    
    //view.addSubview(homeButton)
    /*
     func configureInfoView() {
     let formatter = DateComponentsFormatter()
     formatter.unitsStyle = .brief
     
     formatter.allowedUnits = [.hour, .minute]
     
     guard let timeForPrepare = Double(timeToPrepare) else {
     return
     }
     guard let time = formatter.string(from: Double(timeForPrepare)*60) else {
     return
     }
     title.text = time
     }
     */
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
