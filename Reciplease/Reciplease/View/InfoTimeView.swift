//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoTimeView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    var timeToPrepare = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        //setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
   
    

    
    func setupView() {
        backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)

        titleLabel.textColor = .label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 21, weight:.light)
        let imageToAdd = UIImage(systemName: "clock", withConfiguration: imageSymbolConfiguration)
        let width = imageToAdd?.size.width
        let height = imageToAdd?.size.height
        */
       
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

       
        let contentStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = 5
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    
    /*
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
 */
}
