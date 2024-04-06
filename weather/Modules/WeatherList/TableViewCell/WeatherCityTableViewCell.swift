//
//  WeatherCityTableViewCell.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import UIKit

class WeatherCityTableViewCell: UITableViewCell {
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = UIColor(resource: .headline)
        return label
    }()
    let accessoryIcon: UIImageView = {
        let icon = UIImageView(
            image: UIImage(systemName: "chevron.forward")
        )
        icon.frame.size = CGSize(width: 16, height: 16)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(resource: .content)
        return icon
    }()

    lazy var hStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                weatherLabel,
                accessoryIcon
            ]
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
    }

    func configureSubViews() {
        self.contentView.addSubview(hStack)
        hStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
