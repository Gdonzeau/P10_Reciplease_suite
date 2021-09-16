//
//  InfoPersonView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 16/09/2021.
//

import UIKit

class InfoPersonView: UIView {

    var person = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
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
        let title = UILabel(frame: CGRect(x: 0, y: 32, width: 100, height: 31))
        
        var text = "" {
            didSet {
                title.text = text
            }
        }
        
        return title
    }()
}
