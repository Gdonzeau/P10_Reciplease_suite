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
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let title: UILabel = { // Recipe's time to prepare
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = ""
        return title
    }()
    
    let symbolTime: UIImageView = { // The symbol "Clock" from Apple
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 21, weight:.light)
        let imageToAdd = UIImage(systemName: "clock", withConfiguration: imageSymbolConfiguration)
        let width = imageToAdd?.size.width
        let height = imageToAdd?.size.height
        
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image = UIImageView(image: imageToAdd)
        image.tintColor = UIColor.white

        return image
    }()
    
    func setupView() {
        self.addSubview(title)
        self.addSubview(symbolTime)
        self.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
    
    func setupConstraints() { // Contraintes pour symbolTime et title
        symbolTime.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        symbolTime.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        symbolTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        symbolTime.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: 0).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: symbolTime.trailingAnchor, constant: 0).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
}
