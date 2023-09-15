//
//  CalendarCollectionViewCell.swift
//  02
//
//  Created by Марина on 25.02.2023.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private let dayofWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "We"
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
//        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfDayLabel: UILabel = {
        let label = UILabel()
        label.text = "22"
        label.font = .robotoBold20()
        label.textColor = .white
        label.textAlignment = .center
//        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                backgroundColor = .specialYellow
                dayofWeekLabel.textColor = .specialBlack
                numberOfDayLabel.textColor = .specialDarkGreen
            } else {
                backgroundColor = .specialGreen
                dayofWeekLabel.textColor = .white
                numberOfDayLabel.textColor = .white
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = 10
        
        addSubview(dayofWeekLabel)
        addSubview(numberOfDayLabel)
    }
    
    public func dateForCell(numberOfDay: String, dayOfWeek: String) {
        dayofWeekLabel.text = dayOfWeek
        numberOfDayLabel.text = numberOfDay
    }
}

extension CalendarCollectionViewCell {
    
    private func setConstaints() {
        NSLayoutConstraint.activate([
            dayofWeekLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayofWeekLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            
            numberOfDayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberOfDayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
}
