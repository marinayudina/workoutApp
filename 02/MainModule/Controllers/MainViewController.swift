//
//  ViewController.swift
//  02
//
//  Created by Марина on 20.02.2023.
//

import UIKit

class MainViewController: UIViewController {
 
    public var selectedDate: Date = Date()
    
    private lazy var userPhotoImageView: UIImageView = {
        
       let imageView = UIImageView()
        
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your name"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5 // от изначального
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.tintColor = .specialDarkGreen //цвет заливки
         //edge край inset отступ
        button.imageEdgeInsets = .init(top: 0,
                                       left: 20,
                                       bottom: 15,
                                       right: 0)
        button.titleEdgeInsets = .init(top: 50,
                                       left: -40,
                                       bottom: 0,
                                       right: 0)
        button.titleLabel?.font = .robotoMedium12()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addShadowOnView()
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noWorkout")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let workoutTodayLabel = UILabel(text: "Workout today")
    private let tableView = MainTableView()
    
    private var workoutArray = [WorkoutModel]()

    override func viewDidLayoutSubviews() {//отработает при перерисовке
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectItem(date: selectedDate)
        setupUserParameters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboarding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupViews()
        setConstaints()
        getWeather()
    }

    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(calendarView)
        calendarView.setDelegate(self)
         
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        tableView.mainDelegate = self
        view.addSubview(noWorkoutImageView)
    }
    
    @objc private func addWorkoutButtonTapped() {
        let newWorkoutViewConroller = NewWorkoutViewController()
        newWorkoutViewConroller.modalPresentationStyle = .fullScreen
        present(newWorkoutViewConroller, animated: true)
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let dateStart = date.startEndDate().start
        let dateEnd = date.startEndDate().end
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or,
                                           subpredicates: [predicateRepeat, predicateUnRepeat])
        
    
        
        let resultArray = RealmManager.shared.getResultsWorkoutModel()
        let filterArray = resultArray.filter(compound).sorted(byKeyPath: "workoutName")
        workoutArray = filterArray.map {$0}
    }
    
    private func checkWorkoutsToday() {
//        if workoutArray.count == 0 {
//            noWorkoutImageView.isHidden = false
//            tableView.isHidden = true
//        } else {
//            noWorkoutImageView.isHidden = true
//            tableView.isHidden = false
//        }
        
        noWorkoutImageView.isHidden = !workoutArray.isEmpty
        tableView.isHidden = workoutArray.isEmpty
    }
    private func setupUserParameters() {
        
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
          
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data) else {
                return
            }
            userPhotoImageView.image = image
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] result, error in
            guard let self = self else {return}
            if let model = result {
                print(model)
                self.weatherView.updateLabels(model: model)
                NetworkImageRequest.shared.requestData(id: model.weather[0].icon) { result in
                    switch result {
                    case .success(let data):
                        self.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if onBoardingWasViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
        }
    }
}

extension MainViewController: CalendarViewProtocol {
    func selectItem(date: Date) {
        
        self.selectedDate = date
        getWorkouts(date: date)
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
        checkWorkoutsToday()
    }
}

extension MainViewController: WorkoutCellProtocol {
    func startButtonTapped(model: WorkoutModel) {
        if model.workoutTimer == 0 {
            let repsWorkoutViewController = RepsWorkoutViewController()
            repsWorkoutViewController.modalPresentationStyle = .fullScreen
            repsWorkoutViewController.setWorkoutModel(model)
            present(repsWorkoutViewController, animated: true)
        } else {
//            print("timer")
            let timerWorkoutViewController = TimerWorkoutViewController()
            timerWorkoutViewController.modalPresentationStyle = .fullScreen
            timerWorkoutViewController.setWorkoutModel(model)
            present(timerWorkoutViewController, animated: true)
        }
    }
}

extension MainViewController: MainTableViewProtocol {
    func deleteWorkout(model: WorkoutModel, index: Int) {
        RealmManager.shared.deleteWorkoutModel(model)
        workoutArray.remove(at: index)
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
    }
}

extension MainViewController {
    private func setConstaints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
//            addWorkoutButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
//            addWorkoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
            
            
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
//            weatherView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
            
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            noWorkoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImageView.heightAnchor.constraint(equalTo: noWorkoutImageView.widthAnchor, multiplier: 1)
            
        ])
    }
}
