//
//  WeatherListViewController.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 04/04/2024.
//

import UIKit
import Combine

class WeatherListViewController: UIViewController {
    // MARK: - View Model
    var viewModel: WeatherListViewModel!

    // MARK: - Coordinator
    var coordinator: Coordinator<WeatherRoute>!
    var store = [AnyCancellable]()

    // MARK: - UI Elements
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addButtonBG: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(resource: .buttonRight)
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var addButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { _ in
                self.addCityPopup()
            }
        )
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var emptyStateLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "You haven't added any cities, yet."
        self.view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        return textLabel
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        configureTableView()

        configureAddButton()
        configureTitleLabel()

        subscribeToUpdate()
        subscribeToEmptyState()
    }

    // MARK: - UI Configuration
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchCitiesFromDataBase()
        configureBackground()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherCityTableViewCell.self, forCellReuseIdentifier: "WeatherCellId")

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
    }

    func configureAddButton() {
        view.addSubview(addButtonBG)
        addButtonBG.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButtonBG.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        view.addSubview(addButton)
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        view.bringSubviewToFront(addButton)
    }

    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
        titleLabel.text = "Cities".uppercased()
    }


    func configureBackground() {
        view.backgroundColor = UIColor(resource: .background)
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

    func addCityPopup() {
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

extension WeatherListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCities
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellId", for: indexPath) as? WeatherCityTableViewCell else { return UITableViewCell() }
        cell.weatherLabel.text = viewModel.city(at: indexPath.row)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.navigate(.history(viewModel.city(at: indexPath.row)), transition: .push)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
