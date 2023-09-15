//
//  SelectionWorkoutCell.swift
//  02
//
//  Created by Марина on 14.03.2023.
//

import UIKit

class SelectWorkoutCell: UICollectionViewCell {
    
    static let idSelectionWorkoutCell = "idSelectionWorkoutCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testWorkout")?.withRenderingMode(.alwaysTemplate)//для заливки
        imageView.tintColor = .specialDarkGreen
        imageView.contentMode = .scaleAspectFit //чтобы не растянулось
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let imageCell: UIView =  {
        let imageCell = UIView()
        imageCell.layer.cornerRadius = 10
        imageCell.backgroundColor = .specialBackground
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        return imageCell
    }()
    
    override var isSelected: Bool {
        willSet(newValue) {
            if newValue {
                backgroundColor = .specialDarkGreen //Цвет выделенной ячейки
            } else {
                backgroundColor = .none //Цвет не выделенной
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .specialBrown
//        backgroundColor = .white
        self.addSubview(imageCell)
        imageCell.addSubview(imageView)
        setConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(nameImage: String) {
        imageView.image = UIImage(named: nameImage)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
    }
}

extension SelectWorkoutCell {
    private func setConstarints() {
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            imageCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            imageView.topAnchor.constraint(equalTo: imageCell.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -5)
        ])
    }
}
