//
//  HistoryListViewController.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import UIKit
import Combine

class HistoryListViewController: UIViewController {
    // MARK: - ViewModel
    var viewModel: HistoryListViewModel!

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

    lazy var backButtonBG: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(resource: .buttonLeft)
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { _ in
                self.navigationController?.popViewController(animated: true)
            }
        )
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycle/ UI Configuration
    override func viewDidLoad() {
        configureTableView()
        configureBackground()
        self.view.backgroundColor = UIColor(resource: .background)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        configureTitleLabel()
        configureBackButton()
        subscribeToUpdate()
        viewModel.fetchEntriesFromDataBase()
    }

    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        titleLabel.text = "\(viewModel.city)\nHistorical".uppercased()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherItemTableViewCell.self, forCellReuseIdentifier: "WeatherItemTableViewCell")

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
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

    func configureBackButton() {
        view.addSubview(backButtonBG)
        backButtonBG.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backButtonBG.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }

    func subscribeToUpdate() {
        viewModel.reloadPublisher.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &store)
    }
}

// MARK: UITableViewDelegate + UITableViewDataSource
extension HistoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherItemTableViewCell", for: indexPath) as? WeatherItemTableViewCell else { return UITableViewCell() }
        let item = viewModel.item(at: indexPath.row)
        cell.weatherLabel.text = "\(item.desc), \(item.temperature)"
        cell.dateLabel.text = item.date.formatted(date: .numeric, time: .shortened)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        coordinator.navigate(.details(item, item.date), transition: .modal)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
