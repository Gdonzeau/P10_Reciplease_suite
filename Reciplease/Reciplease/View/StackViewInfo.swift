//
//  StackViewInfo.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 16/09/2021.
//

import UIKit

class StackViewInfo: UIStackView {
    
    var duration: Float? {
        didSet {
            
            guard let duration = duration, duration != 0.0 else {
                codeInfoTimeView.isHidden = true
                return
            }
            
            codeInfoTimeView.image = UIImage(systemName: "clock")
            codeInfoTimeView.title = dateComponentsFormatter.string(from: Double(duration * 60))
        }
    }
    
    var persons: Float? {
        didSet {
            guard let persons = persons else { return }
            
            codeInfoPersonView.image = UIImage(systemName: "person")
            codeInfoPersonView.title = "\(persons) pers. "
        }
    }

    private let codeInfoTimeView = InfoView()
    private let codeInfoPersonView = InfoView()
    
    private var dateComponentsFormatter: DateComponentsFormatter {
        let timeToConvert = DateComponentsFormatter()
        timeToConvert.unitsStyle = .brief
        timeToConvert.allowedUnits = [.hour, .minute]
        return timeToConvert
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        alignment = .fill
        axis = .vertical
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(codeInfoTimeView)
        addArrangedSubview(codeInfoPersonView)
        
    }
}
