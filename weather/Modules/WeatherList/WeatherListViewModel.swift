//
//  WeatherListViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 04/04/2024.
//

import Foundation
import Combine
import RealmSwift

protocol WeatherListViewModel {
    func fetchCitiesFromDataBase()
    func city(at index: Int) -> String
    var isEmpty: AnyPublisher<Bool, Never> { get }
    var reloadPublisher: AnyPublisher<Void, Never> { get }
    var numberOfCities: Int { get }
}

class DefaultWeatherListViewModel: WeatherListViewModel {
    private let subject: CurrentValueSubject<[String], Never> = CurrentValueSubject([])
    private var cities: [String] { subject.value }

    func fetchCitiesFromDataBase() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            let logs = realm.objects(WeatherViewModel.self)
            print(logs)
            var cities: [String] = []
            for log in logs {
                cities.append(log.name)
            }
            self.subject.send(
                cities.removingDuplicates()
            )
        }
    }


    var isEmpty: AnyPublisher<Bool, Never> {
        subject
            .map(\.isEmpty)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    /// Fires whenever the subject value is updated.
    var reloadPublisher: AnyPublisher<Void, Never> {
        subject
            .removeDuplicates()
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    var numberOfCities: Int { subject.value.count }

    func city(at index: Int) -> String {
        subject.value[index]
    }
}

extension Array where Element == String {
    func removingDuplicates() -> [String] {
        var uniqueElements = [String]()
        var encountered = Set<String>()

        for element in self {
            if !encountered.contains(element) {
                uniqueElements.append(element)
                encountered.insert(element)
            }
        }

        return uniqueElements
    }
}
