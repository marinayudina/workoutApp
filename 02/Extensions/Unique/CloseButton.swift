//
//  CloseButton.swift
//  02
//
//  Created by Марина on 06.03.2023.
//

import UIKit

class CloseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
