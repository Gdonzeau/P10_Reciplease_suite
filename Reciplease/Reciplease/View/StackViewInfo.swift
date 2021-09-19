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
        
        setupView()
        subViewsConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .orange
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(codeInfoTimeView)
        self.addSubview(codeInfoPersonView)
    }
    func subViewsConstraints() {
        codeInfoTimeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive  = true
        codeInfoTimeView.bottomAnchor.constraint(equalTo: codeInfoPersonView.topAnchor, constant: 0).isActive = true
        
        codeInfoPersonView.topAnchor.constraint(equalTo: codeInfoTimeView.bottomAnchor, constant: 0).isActive = true
        codeInfoPersonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
}
