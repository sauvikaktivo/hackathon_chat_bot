//
//  BotChatViewController.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit
import Combine

class ChatViewController: UIViewController {

    var currentWeightInput: Double?
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    private lazy var chatMsgBox: ChatMessageComposeView = {
        let b = ChatMessageComposeView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.delegate = self
        return b
    }()
    let controller = ChatController()
    var dataSource: UICollectionViewDiffableDataSource<ChatBotSection, ChatBotItem>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLayout()
        configureDataSource()
        
        // API Test Code
        controller.view = self
        controller.loadDayFirstLaunchConfig()
    }
    
    func configLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(chatMsgBox)
        NSLayoutConstraint.activate([
            chatMsgBox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatMsgBox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatMsgBox.heightAnchor.constraint(equalToConstant: 60),
            chatMsgBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        view.addSubview(collectionView)
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatMsgBox.topAnchor),
        ])
    }
    func configureDataSource() {
        
        let gridActionCellRegistration = UICollectionView.CellRegistration<GridCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        let botMessageCellRegistration = UICollectionView.CellRegistration<BotMessageCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        let userMessageCellRegistration = UICollectionView.CellRegistration<UserMessageCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        let quickActionCellRegistration = UICollectionView.CellRegistration<QuickActionCell, ChatBotItem> { (cell, indexPath, item) in
            cell.delegate = self
            cell.configure(item: item, indexPath: indexPath)
        }
        let addWeightCellRegistration = UICollectionView.CellRegistration<AddWeightCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
            cell.delegate = self
        }
        
        dataSource = UICollectionViewDiffableDataSource<ChatBotSection, ChatBotItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ChatBotItem) -> UICollectionViewCell? in
            // Return the cell.
            guard let sectionType = self.controller.sectionType(sectionIndex: indexPath.section) else { return nil }
            switch sectionType {
            case .titleGridLayout:
                return collectionView.dequeueConfiguredReusableCell(using: gridActionCellRegistration, for: indexPath, item: item)
            case .addWeight:
                return collectionView.dequeueConfiguredReusableCell(using: addWeightCellRegistration, for: indexPath, item: item)
            case .botMessages:
                return collectionView.dequeueConfiguredReusableCell(using: botMessageCellRegistration, for: indexPath, item: item)
            case .userMessage:
                return collectionView.dequeueConfiguredReusableCell(using: userMessageCellRegistration, for: indexPath, item: item)
            case .quickActionOptions:
                return collectionView.dequeueConfiguredReusableCell(using: quickActionCellRegistration, for: indexPath, item: item)
            }
        }
        applySnapshot(animateDiff: false)
    }
    func applySnapshot(animateDiff: Bool) {
        
        // Prepare the snapshot
        var snapshot = NSDiffableDataSourceSnapshot<ChatBotSection, ChatBotItem>()
        for section in controller.sections {
            snapshot.appendSections([section])
            switch section {
            case .titleGridLayout(let model):
                snapshot.appendItems(model.grid.items.map { ChatBotItem.titleGridItem(item: ChatBotGridItem(item: $0)) }, toSection: section)
            case .addWeight:
                snapshot.appendItems([.addWeightItem(item: ChatBotAddWeightItem())], toSection: section)
            case .botMessages(let model):
                snapshot.appendItems(model.msgs.map { ChatBotItem.botMessage(item: ChatBotMessageItem(msg: $0)) }, toSection: section)
            case .userMessage(let model):
                snapshot.appendItems([ChatBotItem.userMessage(item: UserMessageItem(msg: model.item.msg))], toSection: section)
            case .quickActionOptions(let model):
                snapshot.appendItems(model.actions.map { ChatBotItem.quickAction(item: ChatBotQuickActionItem(action: $0)) }, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animateDiff) { [weak self] in
            guard let lastItem = self?.controller.indexPathForLastItem() else { return }
            self?.collectionView.scrollToItem(at: lastItem, at: .bottom, animated: animateDiff)
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, layoutEnv in
            guard let self = self else { fatalError("Self not found") }
            guard let sectionType = self.controller.sectionType(sectionIndex: sectionIndex) else {
                fatalError("Invalid section index, could not find section to attach")
            }
            switch sectionType {
            case .titleGridLayout(let sectionModel):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.3))
                let singleLineGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                       subitem: item, count: sectionModel.cols)
                let section = NSCollectionLayoutSection(group: singleLineGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section
            case .addWeight:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(200))
                let singleLineGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: singleLineGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                return section
            case .botMessages:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(4),top: .fixed(8),
                                                                 trailing: .fixed(4),bottom: .fixed(8))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(100))
                let msgGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let msgSection = NSCollectionLayoutSection(group: msgGroup)
                msgSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 16)
                return msgSection
            case .userMessage:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(60))
                let msgGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                let msgSection = NSCollectionLayoutSection(group: msgGroup)
                msgSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                return msgSection
            case .quickActionOptions(let model):
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40),
                                                      heightDimension: .absolute(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: model.actionCount)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        })
        return layout
    }
}

extension ChatViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemTapped = dataSource.itemIdentifier(for: indexPath) else { return }
        controller.reportQuickAction(item: itemTapped)
    }
}
extension ChatViewController: AddWeightCellDelegate {
    func addWeightCell(_ cell: AddWeightCell, didChange weightText: String?) {
        guard let weightText = weightText else { return }
        currentWeightInput = Double(weightText)
        print (cell.unitToggle.selectedSegmentIndex == 0 ? "KG": "LBS")
    }
}
extension ChatViewController : QuickActionCellDelegate {
    func didTapOnQuickActionButton(indexPath: IndexPath) {
        guard let itemTapped = dataSource.itemIdentifier(for: indexPath) else { return }
        controller.reportQuickAction(item: itemTapped)
    }
}
extension ChatViewController : ChatMessageComposeViewDelegate {
    func chatMessageComposer(_ view: ChatMessageComposeView, didTapSendButton button: UIButton) {
        controller.reportUserRequest(text: view.textField.text)
        view.reset()
    }
}

