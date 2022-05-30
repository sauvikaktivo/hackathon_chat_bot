//
//  BotChatViewController.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit
import Combine

class ChatViewController: UIViewController {

    private lazy var disposables = Set<AnyCancellable>()
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    let controller = ChatController()
    var dataSource: UICollectionViewDiffableDataSource<ChatBotSection, ChatBotItem>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLayout()
        configureDataSource()
        
        // API Test Code
        API<ChatBotResponse>.load(endPoint: ChatBotServerEndPoint.dayFirstLaunch())
            .sink(receiveCompletion: { state in
                switch state {
                case .finished:
                    break
                case .failure(let error):
                    print("API Load error: \(error)")
                }
            }, receiveValue: { result in
                if let gridItems = result.layout?.layout?.grid {
                    self.controller.sections.append(ChatBotSection.titleGridLayout(sectionModel: TitleGridLayoutSection(grid: gridItems)))
                }
                if let msgs = result.messages {
                    self.controller.sections.append(ChatBotSection.botMessages(sectionModel: BotMessagesSection(messages: msgs)))
                }
                if let quickActions = result.quickActions {
                    self.controller.sections.append(ChatBotSection.quickActionOptions(sectionModel: QuickActionSection(actions: quickActions)))
                }
                self.configureDataSource()
            }).store(in: &disposables)
    }
    
    func configLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    func configureDataSource() {
        
        let gridActionCellRegistration = UICollectionView.CellRegistration<GridCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        let botMessageCellRegistration = UICollectionView.CellRegistration<BotMessageCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        let quickActionCellRegistration = UICollectionView.CellRegistration<QuickActionCell, ChatBotItem> { (cell, indexPath, item) in
            cell.configure(item: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<ChatBotSection, ChatBotItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ChatBotItem) -> UICollectionViewCell? in
            // Return the cell.
            guard let sectionType = self.controller.sectionType(sectionIndex: indexPath.section) else { return nil }
            switch sectionType {
            case .titleGridLayout:
                return collectionView.dequeueConfiguredReusableCell(using: gridActionCellRegistration, for: indexPath, item: item)
            case .botMessages:
                return collectionView.dequeueConfiguredReusableCell(using: botMessageCellRegistration, for: indexPath, item: item)
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
            case .botMessages(let model):
                snapshot.appendItems(model.msgs.map { ChatBotItem.botMessage(item: ChatBotMessageItem(msg: $0)) }, toSection: section)
            case .quickActionOptions(let model):
                snapshot.appendItems(model.actions.map { ChatBotItem.quickAction(item: ChatBotQuickActionItem(action: $0)) }, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animateDiff)
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
            case .botMessages(let model):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(100))
                let msgGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: model.msgCount)
                let msgSection = NSCollectionLayoutSection(group: msgGroup)
                msgSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                return msgSection
            case .quickActionOptions(let model):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(68))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(100))
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
    
}
