//
//  WeatherItemTableViewCell.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import UIKit

class WeatherItemTableViewCell: UITableViewCell {
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .content)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(resource: .headline)
        return label
    }()

    lazy var vStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                dateLabel,
                weatherLabel
            ]
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
    }

    func configureSubViews() {
        self.contentView.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
