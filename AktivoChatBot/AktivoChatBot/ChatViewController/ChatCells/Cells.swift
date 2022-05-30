//
//  Cells.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit

class GridCell: UICollectionViewCell {
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


class BotMessageCell: UICollectionViewCell {
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
class QuickActionCell: UICollectionViewCell {
    static let identifier = "QuickActionCell"
    weak var delegate: QuickActionCellDelegate?
    var indexPath: IndexPath?
    lazy var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .secondarySystemBackground
        b.layer.borderWidth = 1.0
        b.layer.cornerRadius = 28
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
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
        button.setTitle(model.action.buttonTitle, for: .normal)
    }
    @objc
    func buttonTapped() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapOnQuickActionButton(indexPath: indexPath)

    }
}


extension UIColor {
    static let chatBotMessage = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
    static let quickActionBorderColor = UIColor(red: 219/255.0, green: 222/255.0, blue: 225/255.0, alpha: 1)
    static let quickActionTextColor = UIColor(red: 53/255.0, green: 129/255.0, blue: 184/255.0, alpha: 1)
}
