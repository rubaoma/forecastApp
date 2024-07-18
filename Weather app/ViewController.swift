//
//  ViewController.swift
//  Weather app
//
//  Created by Rubens Moura Augusto on 05/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.constrastColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var tempetureLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Umidade"
        label.textColor = UIColor.constrastColor
        return label
    }()
    
    private lazy var humidityValueLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.constrastColor
        return label
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: [humidityLabel, humidityValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        return stackView
    }()
    
    private lazy var windLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Vento"
        label.textColor = UIColor.constrastColor
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.constrastColor
        return label
    }()
    
    private lazy var windStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: [windLabel, windValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        return stackView
    }()
    
    private lazy var statsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityStackView, windStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.backgroundColor = UIColor.softGray
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        return stackView
    }()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "PREVISÃO A CADA 3 HORAS"
        label.textColor = UIColor.constrastColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hourlyColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 68, height: 84)
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 12)
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "PRÓXIMOS DIAS"
        label.textColor = UIColor.constrastColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dailyForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.indentifier)
        return tableView
    }()
    
    private let service = ServiceApi()
    private var city = City(lat: "-3.71839", lon: "-38.5434", name: "Fortaleza")
    private var forecastNowResponse: ForecastNowResponse?
    private var weekForecastResponse: WeekForecastResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
       
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            service.fetchDataforecastNow(city: city) { [weak self] response in
                self?.forecastNowResponse = response
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            service.fetchDataWeekForecast(city: city) { [weak self] response in
                self?.weekForecastResponse = response
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.loadData()
            }
//        service.fetchDataforecastNow(city: city) { [weak self] response in
//            self?.forecastNowResponse = response
//            DispatchQueue.main.async {
//                self?.loadData()
//            }
//        }
//        service.fetchDataWeekForecast(city: city) { [weak self] response in
//            self?.weekForecastResponse = response
//            DispatchQueue.main.async {
//                self?.loadData()
//            }
//        }
        
    }
    
    private func loadData(){
        cityLabel.text = city.name
        tempetureLabel.text = forecastNowResponse?.main.temp.toCelsius()
        humidityValueLabel.text = "\(forecastNowResponse?.main.humidity ?? 0) mm"
        windValueLabel.text = "\(forecastNowResponse?.wind.speed ?? 0) km/h"
        weatherIcon.image = UIImage(named: forecastNowResponse?.weather.first?.icon ?? "")
        
        autoHourSelectBackground()
        
        hourlyColectionView.reloadData()
        dailyForecastTableView.reloadData()
        
    }
    
    private func autoHourSelectBackground() {
        if forecastNowResponse?.dt.isDayTime() ?? true {
            backgroundView.image = UIImage(named: "background-day")
        } else {
            backgroundView.image = UIImage(named: "background-nigth")
        }
    }
    
    private func setupView(){
        view.backgroundColor = .white
        // always add the custonView on the view before contraint customView
        setHierarchy()
        //create the constraints
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(statsStackView)
        view.addSubview(hourlyForecastLabel)
        view.addSubview(hourlyColectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTableView)
        
        headerView.addSubview(cityLabel)
        headerView.addSubview(tempetureLabel)
        headerView.addSubview(weatherIcon)
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(
                equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tempetureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),
            tempetureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            tempetureLabel.heightAnchor.constraint(equalToConstant: 70),
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            weatherIcon.centerYAnchor.constraint(equalTo: tempetureLabel.centerYAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: tempetureLabel.trailingAnchor, constant: 14)
        ])
        
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            statsStackView.widthAnchor.constraint(equalToConstant: 206),
            statsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            hourlyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            hourlyColectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 22),
            hourlyColectionView.heightAnchor.constraint(equalToConstant: 84),
            hourlyColectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyColectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo: hourlyColectionView.bottomAnchor,constant: 30),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            dailyForecastTableView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 14),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weekForecastResponse?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:HourlyForecastCollectionViewCell.identifier,
            for: indexPath) as? HourlyForecastCollectionViewCell else {
           return UICollectionViewCell()
       }
        
        let forecastWeek = weekForecastResponse?.list[indexPath.row]
        cell.loadData(time: forecastWeek?.dt.toHourFormat(),
                      icon: UIImage(named: forecastWeek?.weather.first?.icon ?? ""),
                      temp: forecastWeek?.main.temp.toCelsius())
        return cell
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekForecastResponse?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyForecastTableViewCell.indentifier,
            for: indexPath) as? DailyForecastTableViewCell else {
                return UITableViewCell()
            }
        
        let dayWeekForecast = weekForecastResponse?.list[indexPath.row]
        cell.loadData(weekDay: dayWeekForecast?.dt.toWeekdayName().uppercased(),
                      min: dayWeekForecast?.main.tempMin.toCelsius(),
                      max: dayWeekForecast?.main.tempMax.toCelsius(),
                      icon: UIImage(named: dayWeekForecast?.weather.first?.icon ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

