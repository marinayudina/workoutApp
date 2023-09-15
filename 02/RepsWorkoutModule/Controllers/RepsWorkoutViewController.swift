//
//  RepsWorkoutViewController.swift
//  02
//
//  Created by Марина on 03.04.2023.
//

import UIKit

class RepsWorkoutViewController: UIViewController {
    
    private let StartWorkoutLabel = UILabel(text: "START WORKOUT",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private lazy var closeButton = CloseButton(type: .system)
    
    private let sportmanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sportsman")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let workoutParametersView = WorkoutParametrsView()
    
    private lazy var finishButton = GreenButton(text: "FINISH")
    
    private var workoutModel = WorkoutModel()
    
    private var customAlert = CustomAlert()
    private var numberOfSet = 1
    

    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
//        print(workoutModel)
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(StartWorkoutLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped),
                              for: .touchUpInside)
        
        view.addSubview(sportmanImageView)
        view.addSubview(detailsLabel)
        
        view.addSubview(workoutParametersView)
        workoutParametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        workoutParametersView.cellNextSetDelegate = self
        
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped),
                               for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            presentAlertWithActions(title: "Warning", message: "You haven't your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    public func setWorkoutModel(_ model: WorkoutModel) {
        workoutModel = model
    }
}

//MARK: -
extension RepsWorkoutViewController: NextSetProtocol {
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        } else {
            presentSimpleAlert(title: "Error", message: "Finish your workout")
        }
    }
    
    func editingTapped() {
        customAlert.presentCustomAlert(viewController: self,
                                       repsOrTimer: "Reps") { [weak self] sets, reps in
            guard let self = self else { return }
            if sets != "" && reps != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfReps = Int(reps)
                else {
                    return
                }
                RealmManager.shared.updateSetsRepsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               reps: numberOfReps)
                self.workoutParametersView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
//            print(sets, reps)
        }
//        print("!!!")
    }

}

//MARK: - Set Constraints
extension RepsWorkoutViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            StartWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 10),
            StartWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            closeButton.centerYAnchor.constraint(equalTo: StartWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),

            sportmanImageView.topAnchor.constraint(equalTo: StartWorkoutLabel.bottomAnchor, constant: 30),
            sportmanImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sportmanImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            sportmanImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),


            detailsLabel.topAnchor.constraint(equalTo: sportmanImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            workoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor,
                                                      constant: 5),
            workoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                          constant: 20),
            workoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                           constant: -20),
            workoutParametersView.heightAnchor.constraint(equalToConstant: 230),

            finishButton.topAnchor.constraint(equalTo: workoutParametersView.bottomAnchor,
                                              constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
            
            
            
        ])
    }
}

