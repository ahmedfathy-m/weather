//
//  WeatherListViewController.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 04/04/2024.
//

import UIKit
import Combine

class WeatherListViewController: UITableViewController {
    var viewModel: WeatherListViewModel!
    var coordinator: Coordinator<WeatherRoute>!
    var store = [AnyCancellable]()
    
    lazy var emptyStateLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "You haven't added any cities, yet."
        self.view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        return textLabel
    }()

    override func viewDidLoad() {
        tableView.register(WeatherCityTableViewCell.self, forCellReuseIdentifier: "WeatherCellId")
        configureNavigationItem()
        subscribeToUpdate()
        subscribeToEmptyState()
        viewModel.fetchCitiesFromDataBase()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureBackground()
    }

    func configureBackground() {
        tableView.backgroundColor = UIColor(resource: .background)
        let image = UIImageView(
            image: UIImage(resource: .background)
        )
        let container = UIView()
        tableView.backgroundView = container
        container.addSubview(image)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

    func configureNavigationItem() {
        self.navigationItem.title = "Cities"
        let add = UIBarButtonItem(
            image: .add,
            style: .plain,
            target: self,
            action: #selector(addCityPopup)
        )
        self.navigationItem.rightBarButtonItem = add
    }

    @objc func addCityPopup() {
        coordinator.navigate(.add, transition: .modal)
    }

    func subscribeToUpdate() {
        viewModel.reloadPublisher.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &store)
    }

    func subscribeToEmptyState() {
        viewModel.isEmpty.sink { [weak self] newValue in
            self?.tableView.isHidden = newValue
            self?.emptyStateLabel.isHidden = !newValue
        }.store(in: &store)
    }
}

extension WeatherListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCities
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellId", for: indexPath) as? WeatherCityTableViewCell else { return UITableViewCell() }
        cell.weatherLabel.text = viewModel.city(at: indexPath.row)
        cell.backgroundColor = .clear
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
