//
//  AddCityViewController.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import UIKit
import SVProgressHUD

class AddCityViewController: UIViewController {
    var viewModel: AddCityViewModel!

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter city, postcode or airoport location"
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(
            configuration: .plain(),
            primaryAction: UIAction { [weak self] action in
                self?.dismiss(animated: true)
            }
        )
        button.tintColor = UIColor(resource: .content)
        button.setTitle("Cancel", for: .normal)
        return button
    }()

    lazy var searchTextField: UISearchTextField = {
        let field = UISearchTextField(
            frame: CGRect(),
            primaryAction: UIAction { _ in
                self.fetchCityWeather()
            }
        )
        field.placeholder = "Search"
        field.returnKeyType = .search
        return field
    }()

    lazy var mainStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                searchStack
            ]
        )
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var searchStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                searchTextField,
                cancelButton
            ]
        )
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(resource: .background)
        self.view.addSubview(mainStack)
        mainStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        mainStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
    }

    func fetchCityWeather() {
        searchTextField.resignFirstResponder()
        SVProgressHUD.show()
        Task(priority: .background) {
            let weather = try await viewModel.fetchWeather(city: searchTextField.text)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.dismiss(animated: true)
            }
        }
    }
}
