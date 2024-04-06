//
//  WeatherDetailsViewController.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import UIKit
import SVProgressHUD

class WeatherDetailsViewController: UIViewController {
    // MARK: - ViewModel
    var viewModel: WeatherDetailsViewModel!

    // MARK: - UI Elements
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = viewModel.weather.name.uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dismissButtonBG: UIImageView = {
        let view = UIImageView(
            image: UIImage(resource: .buttonModal)
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var dismissButton: UIButton = {
        let button = UIButton(
            primaryAction: UIAction { _ in
                self.dismiss(animated: true)
            }
        )
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var weatherIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    let card: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .card)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(resource: .shadow).cgColor
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 20)
        view.layer.shadowOpacity = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func createWeatherView() {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 7.0
        vStack.alignment = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        let titles = [
            "Description",
            "temperature",
            "humidity",
            "Windspeed"
        ]
        vStack.addArrangedSubview(weatherIcon)
        titles.enumerated().forEach { index, title in
            let titleLabel = UILabel()
            titleLabel.text = title.uppercased()
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            titleLabel.textColor = UIColor(resource: .headline)
            let valueLabel = UILabel()
            valueLabel.tag = index + 10
            valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            valueLabel.textColor = UIColor(resource: .content)
            let hStack = UIStackView(
                arrangedSubviews: [
                    titleLabel,
                    valueLabel
                ]
            )
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.distribution = .equalSpacing
            vStack.addArrangedSubview(hStack)
        }
        self.view.addSubview(card)

        card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        self.card.addSubview(vStack)

        vStack.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 30).isActive = true
        vStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 55).isActive = true
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(resource: .background)

        createWeatherView()
        configureDismissButton()
        configureTitleLabel()
        configureBackgroundView()
        configureHistoryFooter()
        loadWeatherIcon()
    }

    // MARK: - UI Configuration
    fileprivate func configureDismissButton() {
        self.view.addSubview(dismissButtonBG)
        dismissButtonBG.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dismissButtonBG.topAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true

        self.view.addSubview(dismissButton)
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
    }

    fileprivate func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
    }

    fileprivate func configureBackgroundView() {
        let backgroundImage = UIImageView(
            image: UIImage(resource: .background)
        )
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    fileprivate func configureHistoryFooter() {
        self.view.addSubview(historyLabel)
        historyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        historyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }

    fileprivate func loadWeatherIcon() {
        SVProgressHUD.show()
        Task(priority: .background) {
            let image = UIImage(
                data: try await viewModel.loadImage()
            )
            DispatchQueue.main.async {
                self.weatherIcon.image = image
                (self.view.viewWithTag(10) as? UILabel)?.text = self.viewModel.weather.desc
                (self.view.viewWithTag(11) as? UILabel)?.text = self.viewModel.weather.temperature
                (self.view.viewWithTag(12) as? UILabel)?.text = self.viewModel.weather.humidity
                (self.view.viewWithTag(13) as? UILabel)?.text = self.viewModel.weather.windspeed
                self.historyLabel.text = self.viewModel.historyLabelTitle.uppercased()
                SVProgressHUD.dismiss()
            }
        }
    }
}
