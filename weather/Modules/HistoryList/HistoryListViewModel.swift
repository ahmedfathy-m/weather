//
//  HistoryListViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation
import RealmSwift
import Combine

protocol HistoryListViewModel {
    var city: String { get }
    func fetchEntriesFromDataBase()
    func item(at index: Int) -> WeatherViewModel
    var isEmpty: AnyPublisher<Bool, Never> { get }
    var reloadPublisher: AnyPublisher<Void, Never> { get }
    var numberOfItems: Int { get }
}

class DefaultHistoryListViewModel: HistoryListViewModel {
    let city: String

    init(city: String) {
        self.city = city
    }

    private let subject: CurrentValueSubject<[WeatherViewModel], Never> = CurrentValueSubject([])

    func fetchEntriesFromDataBase() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            let logs = realm.objects(WeatherViewModel.self).filter { $0.name == self.city }
            var items = [WeatherViewModel]()
            for log in logs {
                items.append(log)
            }
            self.subject.send(
                items
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

    var numberOfItems: Int { subject.value.count }

    func item(at index: Int) -> WeatherViewModel {
        subject.value[index]
    }
}
