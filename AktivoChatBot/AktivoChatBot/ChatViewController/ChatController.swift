//
//  ChatController.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import Foundation
import Combine

class ChatController {
    var sections: [ChatBotSection] = []
    private lazy var disposables = Set<AnyCancellable>()
    weak var view: ChatViewController?
    
    func sectionType(sectionIndex: Int) -> ChatBotSection? {
        guard sectionIndex < sections.count else { return nil }
        return sections[sectionIndex]
    }
    func loadDayFirstLaunchConfig() {
        // API Test Code
        API<ChatBotResponse>.load(endPoint: ChatBotServerEndPoint.dayFirstLaunch())
            .sink(receiveCompletion: { state in
                switch state {
                case .finished:
                    break
                case .failure(let error):
                    print("API Load error: \(error)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.updateSectionInfo(result)
                self.view?.configureDataSource()
            }).store(in: &disposables)
    }
    func reportQuickAction(item: ChatBotItem) {
        var chatBotAction: Int?
        switch item {
        case.quickAction(let item): chatBotAction = item.action.botTaskId
        case .titleGridItem(let item): chatBotAction = item.item.botTaskId
        // TODO: Implement Others
        default: return
        }
        guard let taskId = chatBotAction else { return }
        API<ChatBotResponse>.load(endPoint: ChatBotServerEndPoint.quickAction(taskId: taskId))
            .sink(receiveCompletion: { state in
                switch state {
                case .finished:
                    break
                case .failure(let error):
                    print("API Load error: \(error)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.updateSectionInfo(result)
                self.view?.applySnapshot(animateDiff: true)
            }).store(in: &disposables)
    }
    func updateSectionInfo(_ response: ChatBotResponse) {
        if let gridItems = response.layout?.layout?.grid {
            self.sections.append(ChatBotSection.titleGridLayout(sectionModel: TitleGridLayoutSection(grid: gridItems)))
        }
        if let msgs = response.messages {
            self.sections.append(ChatBotSection.botMessages(sectionModel: BotMessagesSection(messages: msgs)))
        }
        if let quickActions = response.quickActions {
            self.sections.append(ChatBotSection.quickActionOptions(sectionModel: QuickActionSection(actions: quickActions)))
        }
    }
}
