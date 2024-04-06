//
//  Routes.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 04/04/2024.
//

import UIKit

protocol Route { 
    func resolveView(coordinator: Coordinator<Self>) -> UIViewController
}

class Coordinator<Router: Route> {
    let root: Router
    let navigationController: UINavigationController

    init(
        root: Router
    ) {
        self.root = root
        self.navigationController = UINavigationController()
        self.navigate(root, transition: .root)
    }

    func navigate(
        _ target: Router,
        transition: Coordinator.Transition
    ) {

        let targetViewController = target.resolveView(coordinator: self)

        switch transition {
        case .root:
            navigationController.setViewControllers([targetViewController], animated: true)
        case .push:
            navigationController.pushViewController(targetViewController, animated: true)
        case .modal:
            targetViewController.modalPresentationStyle = .automatic
            navigationController.present(targetViewController, animated: true)
        case .fullscreen:
            targetViewController.modalPresentationStyle = .fullScreen
            navigationController.present(targetViewController, animated: true)
        }
    }

    enum Transition {
        case push
        case modal
        case fullscreen
        case root
    }

    func assign(to window: UIWindow?) {
        guard let window else { return }
        window.rootViewController = self.navigationController
        window.overrideUserInterfaceStyle = .dark
        window.makeKeyAndVisible()
    }
}

enum WeatherRoute: Route {
    case list
    case add
    case history(city: String)
    case details(city: String)

    func resolveView(coordinator: Coordinator<WeatherRoute>) -> UIViewController {
        switch self {
        case .list:
            let view = WeatherListViewController()
            view.viewModel = DefaultWeatherListViewModel()
            view.coordinator = coordinator
            return view
        case .history(let city):
            return ViewController()
        case .details(let city):
            return ViewController()
        case .add:
            return AddCityViewController()
        }
    }
}
