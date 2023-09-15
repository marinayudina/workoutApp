//
//  StatisticsTableViewCell.swift
//  02
//
//  Created by Марина on 02.03.2023.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium24()
        label.text = "Biceps"
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let BeforeLabel = UILabel(text: "Before:18")
    
    private let NowLabel = UILabel(text: "Now:20")
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium24()
        label.textColor = .specialGreen
        label.textAlignment = .right
        label.text = "+2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelsStackView = UIStackView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(differenceLabel)
        addSubview(nameLabel)
        
        labelsStackView = UIStackView(arrangedSubviews: [BeforeLabel, NowLabel],
                                      axis: .horizontal,
                                      spacing: 10)
        addSubview(labelsStackView)
        addSubview(lineView)
    }
    
    public func configure(differenceWorkout: DifferenceWorkout) {
        nameLabel.text = differenceWorkout.name
        if (differenceWorkout.firstTimer != 0) {
            BeforeLabel.text = "Before: \(differenceWorkout.firstTimer.getTimeFromSeconds())"
            NowLabel.text = "Now: \(differenceWorkout.lastTimer.getTimeFromSeconds())"
        } else {
            BeforeLabel.text = "Before: \(differenceWorkout.firstReps)"
            NowLabel.text = "Now: \(differenceWorkout.lastReps)"
        }

        var difference = 0
        
        if (differenceWorkout.firstTimer != 0)
        {
            difference = differenceWorkout.lastTimer - differenceWorkout.firstTimer
            switch difference {
            case ..<0:
                differenceLabel.textColor = .specialGreen
                differenceLabel.text = "\(difference) sec"
            case 1...:
                differenceLabel.text = "+\(difference) sec"
                differenceLabel.textColor = .specialDarkYellow
            default:
                differenceLabel.text = "\(difference)"
                differenceLabel.textColor = .specialGray
            }
        } else {
            difference = differenceWorkout.lastReps - differenceWorkout.firstReps
            switch difference {
            case ..<0:
                differenceLabel.textColor = .specialGreen
                differenceLabel.text = "\(difference)"
            case 1...:
                differenceLabel.text = "+\(difference)"
                differenceLabel.textColor = .specialDarkYellow
            default:
                differenceLabel.text = "\(difference)"
                differenceLabel.textColor = .specialGray
            }
        }
        

    }
}

extension StatisticsTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            differenceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: differenceLabel.leadingAnchor, constant: -20),
            
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
