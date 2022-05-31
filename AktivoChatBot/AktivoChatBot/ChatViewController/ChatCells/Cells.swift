//
//  Cells.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit

final class GridCell: UICollectionViewCell {
    static let identifier = "GridCell"
    lazy var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.textColor = .label
        return l
    }()
    lazy var image: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        return i
    }()
    lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [image, title])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 12
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30)
        ])
        return s
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(item: ChatBotItem) {
        guard case .titleGridItem(let model) = item else { return }
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ])
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8
        title.text = model.item.title
        image.loadImage(url: model.item.imageUrl)
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.859, green: 0.871, blue: 0.882, alpha: 1).cgColor
    }
}
final class UserMessageCell: UICollectionViewCell {
    static let identifier = "UserMessageCell"
    lazy var textLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .title1)
        l.textColor = UIColor.userMessageText
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .right
        return l
    }()
    lazy var bottomLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.userMessageText
        return l
    }()
    lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [textLabel, bottomLine])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.distribution = .fill
        s.spacing = 8
        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        return s
    }()
    func configure(item: ChatBotItem) {
        guard case .userMessage(let model) = item else { return }
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        textLabel.text = model.msg
    }
}

final class BotMessageCell: UICollectionViewCell {
    static let identifier = "BotMessageCell"
    lazy var textLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.textColor = .label
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .left
        return l
    }()
    lazy var bubble: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.chatBotMessage
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        v.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        v.layer.cornerRadius = 20
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        return v
    }()
    func configure(item: ChatBotItem) {
        guard case .botMessage(let model) = item else { return }
        contentView.addSubview(bubble)
        bubble.addSubview(textLabel)
        textLabel.text = model.msg.message
        NSLayoutConstraint.activate([
            bubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
            textLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8),
        ])
    }
}

protocol QuickActionCellDelegate: AnyObject {
    func didTapOnQuickActionButton(indexPath: IndexPath)
}
final class QuickActionCell: UICollectionViewCell {
    static let identifier = "QuickActionCell"
    weak var delegate: QuickActionCellDelegate?
    var indexPath: IndexPath?
    lazy var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .secondarySystemBackground
        b.layer.borderWidth = 1.0
        b.layer.cornerRadius = 18
        b.backgroundColor = .white
        b.layer.borderColor = UIColor.quickActionBorderColor.cgColor
        b.setTitleColor(UIColor.quickActionTextColor, for: .normal)
        b.setTitleColor(UIColor.quickActionTextColor.withAlphaComponent(0.7), for: .highlighted)
        b.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return b
    }()
    func configure(item: ChatBotItem, indexPath: IndexPath) {
        guard case .quickAction(let model) = item else { return }
        self.indexPath = indexPath
        contentView.addSubview(button)
        button.setTitle(model.action.buttonTitle, for: .normal)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    @objc
    func buttonTapped() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapOnQuickActionButton(indexPath: indexPath)

    }
}

final class AddWeightCell: UICollectionViewCell {
    static let identifier = "AddWeightCell"
    lazy var iconImage: UIImageView = {
        let i = UIImageView(image: UIImage(named: "weight_scale"))
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    lazy var iconTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .title3)
        l.textColor = .label
        l.textAlignment = .center
        l.text = "Weight"
        return l
    }()
    lazy var topStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [iconImage, iconTitle])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 16
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 42),
            iconImage.heightAnchor.constraint(equalToConstant: 42)
        ])
        return s
    }()
    lazy var textInputField: UITextField = {
        let f = UITextField()
        f.textAlignment = .right
        f.translatesAutoresizingMaskIntoConstraints = false
        f.borderStyle = .roundedRect
        f.keyboardType = .numberPad
        return f
    }()
    lazy var unitToggle: UISegmentedControl = {
        let kg = UIAction(title: "KG", state: .off, handler: { action in

        })
        let sbs = UIAction(title: "LBS", state: .off, handler: { action in

        })
        let s = UISegmentedControl(items: [kg, sbs])
        s.selectedSegmentIndex = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        s.selectedSegmentTintColor = UIColor.toggleButtonSelectedColor
        return s
    }()
    lazy var hStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [textInputField, unitToggle])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 16
        return s
    }()
    lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [topStack, hStack])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 26
        return s
    }()
    
    func configure(item: ChatBotItem) {
        guard case .addWeightItem = item else { return }
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
}


extension UIColor {
    static let toggleButtonSelectedColor = UIColor(red: 53/255.0, green: 129/255.0, blue: 184/255.0, alpha: 1)
    static let userMessageText = UIColor(red: 0.0/255.0, green: 98/255.0, blue: 188.0/255.0, alpha: 1)
    static let chatBotMessage = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
    static let quickActionBorderColor = UIColor(red: 219/255.0, green: 222/255.0, blue: 225/255.0, alpha: 1)
    static let quickActionTextColor = UIColor(red: 53/255.0, green: 129/255.0, blue: 184/255.0, alpha: 1)
}
