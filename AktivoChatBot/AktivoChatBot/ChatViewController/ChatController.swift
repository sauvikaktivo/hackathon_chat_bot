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
    func indexPathForLastItem() -> IndexPath? {
        guard sections.count > 0 else { return nil }
        let sectionIndex = sections.count - 1
        var itemIndex = 0
        switch sections.last! {
        case .titleGridLayout(let model):
            itemIndex = model.grid.items.count - 1
        case .addWeight:
            itemIndex = 0
        case .botMessages(let model):
            itemIndex = model.msgCount - 1
        case .userMessage:
            itemIndex = 0
        case .quickActionOptions(let model):
            itemIndex = model.actionCount - 1
        }
        return IndexPath(item: itemIndex, section: sectionIndex)
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
    func reportUserRequest(text: String?) {
        guard let text = text else { return }
        
        // Insert new section to show user input
        sections.append(ChatBotSection.userMessage(sectionModel: UserMessageSection(item: UserMessageItem(msg: text))))
        self.view?.applySnapshot(animateDiff: true)
        
        // Server call to get user intent
        API<ChatBotResponse>.load(endPoint: ChatBotServerEndPoint.userInputText(text: text))
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
        
        // Check for incoming server driven layout items
        if let layoutType = response.layout?.type {
            switch layoutType {
                
            // Need to present an option grid
            case .firstLaunchGrid:
                if let gridItem = response.layout?.layout?.grid {
                    self.sections.append(ChatBotSection.titleGridLayout(sectionModel: TitleGridLayoutSection(grid: gridItem)))
                }
             
            // Need to present weight input UI
            case .addWeightUI:
                self.sections.append(ChatBotSection.addWeight(sectionModel: ChatBotItem.addWeightItem(item: ChatBotAddWeightItem())))
            }
        }
        // Check for incoming bot message, add them in a new section
        if let msgs = response.messages {
            self.sections.append(ChatBotSection.botMessages(sectionModel: BotMessagesSection(messages: msgs)))
        }
        
        // Check for quick action buttons, add them in new section
        if let quickActions = response.quickActions {
            self.sections.append(ChatBotSection.quickActionOptions(sectionModel: QuickActionSection(actions: quickActions)))
        }
    }
}
