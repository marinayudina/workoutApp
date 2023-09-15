//
//  StatisticViewController.swift
//  02
//
//  Created by Марина on 01.03.2023.
//

import UIKit

class StatisticViewController: UIViewController {
    
    private let Statisticslabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTICS"
        label.font = UIFont.robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow //заливка выделенного
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any, .foregroundColor : UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor: UIColor.specialGray], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let nameTextField = BrownTextField()
    
    
    private let ExercisesLabel = UILabel(text: "Exercises")
    
    private let tableView = StatisticTableView()
    
    private var workoutArray = [WorkoutModel]()
    private var differenceArray = [DifferenceWorkout]()
    private var filteredArray = [DifferenceWorkout]()
    
    private var isFiltered =  false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStartScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(Statisticslabel)
        view.addSubview(ExercisesLabel)
        view.addSubview(tableView)
        view.addSubview(segmentedControl)
        nameTextField.brownDelegate = self
        view.addSubview(nameTextField)
    }
    
    @objc private func segmentedChanged() {
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offsetDay(day: 7)
            getDifferenceModel(dateStart: dateStart)
//            tableView.setDifferenceArray(array: differenceArray)
        } else {
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        tableView.reloadData()
    }
    
    private func getWorkoutsName() -> [String] {
        var nameArray = [String]()//массив уникальных имен тренировок
        
        let allWorkouts = RealmManager.shared.getResultsWorkoutModel()
        
        for workoutModel in allWorkouts {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        let dateEnd = Date()
        let nameArray = getWorkoutsName()
        let allWorkouts = RealmManager.shared.getResultsWorkoutModel()
        
        for name in nameArray {
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            let filtredArray = allWorkouts.filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            workoutArray = filtredArray.map { $0 }
            
            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else {
                return
            }
            
            guard let lastTimer = workoutArray.last?.workoutTimer,
                  let firstTimer = workoutArray.first?.workoutTimer else {
                return
            }
            
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first, firstTimer: firstTimer, lastTimer: lastTimer)
            differenceArray.append(differenceWorkout)
        }
        tableView.setDifferenceArray(array: differenceArray)
    }
    
    private func setStartScreen() {
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        getDifferenceModel(dateStart: dateToday.offsetDay(day: 7))
        tableView.reloadData()
    }
    
    private func filteringWorkouts(text: String) {
        
        for workout in differenceArray {
            if workout.name.lowercased().contains(text.lowercased()) {
                filteredArray.append(workout)
            }
        }
    }
}

extension StatisticViewController: BrownTextFieldProtocol {
    func typing(range: NSRange, replacementString: String) {
        if let text = nameTextField.text,
           let textRange = Range(range,in: text) {
            let updateText = text.replacingCharacters(in: textRange, with: replacementString)
            
            filteredArray = [DifferenceWorkout]()
            isFiltered = updateText.count > 0
            filteringWorkouts(text: updateText)
        }
        
        if isFiltered {
            tableView.setDifferenceArray(array: filteredArray)
        } else {
            tableView.setDifferenceArray(array: differenceArray)
        }
        tableView.reloadData()
    }

    func clear() {
        isFiltered = false
        differenceArray = [DifferenceWorkout]()
        let dateToday = Date().localDate()
//        if segmentedControl.selectedSegmentIndex == 1 {
            getDifferenceModel(dateStart: dateToday.offsetDay(day: 7)) 
//        else {
//            getDifferenceModel(dateStart: dateToday.offsetMonth(month: 1)) }
        tableView.reloadData()
        }
    }

                               
extension StatisticViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            Statisticslabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 10),
            Statisticslabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),

            segmentedControl.topAnchor.constraint(equalTo: Statisticslabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
            
            ExercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ExercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ExercisesLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: ExercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
