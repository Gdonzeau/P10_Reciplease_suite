//
//  StackViewInfo.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 16/09/2021.
//

import UIKit

class StackViewInfo: UIStackView {
    var codeInfoTimeView = InfoTimeView()
    var codeInfoPersonView = InfoPersonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
        setupView()
        
        //setupView()
        //setupConstraints()
        //setupLikeButtonConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(codeInfoTimeView)
        self.addSubview(codeInfoPersonView)
    }
}
