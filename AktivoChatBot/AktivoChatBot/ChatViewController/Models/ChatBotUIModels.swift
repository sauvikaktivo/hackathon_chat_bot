//
//  ChatBotUIModels.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import Foundation

// MARK: Section Types
enum ChatBotSection: Hashable {
    case titleGridLayout(sectionModel: TitleGridLayoutSection)
    case botMessages(sectionModel: BotMessagesSection)
    case userMessage(sectionModel: UserMessageSection)
    case quickActionOptions(sectionModel: QuickActionSection)
}

struct TitleGridLayoutSection {
    let id = UUID()
    var cols: Int { grid.colMax }
    let grid: Grid
    init(grid: Grid) {
        self.grid = grid
    }
}
struct BotMessagesSection {
    let id = UUID()
    var msgCount: Int { msgs.count }
    let msgs: [Message]
    init(messages: [Message]) {
        self.msgs = messages
    }
}
struct UserMessageSection {
    let id = UUID()
    let item: UserMessageItem
    init(item: UserMessageItem) {
        self.item = item
    }
}
struct QuickActionSection {
    let id = UUID()
    var actionCount: Int { actions.count }
    let actions: [QuickAction]
    init(actions: [QuickAction]) {
        self.actions = actions
    }
}
extension TitleGridLayoutSection: Hashable {
    static func == (lhs: TitleGridLayoutSection, rhs: TitleGridLayoutSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension BotMessagesSection: Hashable {
    static func == (lhs: BotMessagesSection, rhs: BotMessagesSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension UserMessageSection: Hashable {
    static func == (lhs: UserMessageSection, rhs: UserMessageSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension QuickActionSection: Hashable {
    static func == (lhs: QuickActionSection, rhs: QuickActionSection) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: Item Types
enum ChatBotItem: Hashable {
    case titleGridItem(item: ChatBotGridItem)
    case botMessage(item: ChatBotMessageItem)
    case userMessage(item: UserMessageItem)
    case quickAction(item: ChatBotQuickActionItem)
}

struct ChatBotGridItem {
    let id = UUID()
    let item: Grid.Item
}

struct ChatBotMessageItem {
    let id = UUID()
    let msg: Message
}
struct UserMessageItem {
    let id = UUID()
    let msg: String
}
struct ChatBotQuickActionItem {
    let id = UUID()
    let action: QuickAction
}

extension ChatBotGridItem: Hashable {
    static func == (lhs: ChatBotGridItem, rhs: ChatBotGridItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension ChatBotQuickActionItem: Hashable {
    static func == (lhs: ChatBotQuickActionItem, rhs: ChatBotQuickActionItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension UserMessageItem: Hashable {
    static func == (lhs: UserMessageItem, rhs: UserMessageItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension ChatBotMessageItem: Hashable {
    static func == (lhs: ChatBotMessageItem, rhs: ChatBotMessageItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
