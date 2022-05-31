//
//  ChatBotModels.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import Foundation

// MARK: - Welcome6
struct ChatBotResponse: Decodable {
    let layout: ChatBotServerUI?
    let messages: [Message]?
    let quickActions: [QuickAction]?
}

enum ChatBotServerUIType: String,Decodable {
    case firstLaunchGrid
    case addWeightUI
}
// MARK: - ChatBotServerUI
struct ChatBotServerUI: Decodable {
    let id: String
    let type: ChatBotServerUIType
    let layout: Layout?
}

// MARK: - Layout
struct Layout: Decodable {
    let text: Text
    let grid: Grid
}

// MARK: - Grid
struct Grid: Decodable {
    let colMax: Int
    let sizeType, shape: String
    let items: [Item]
    
    // MARK: - Item
    struct Item: Decodable {
        let title, imageUrl: String
        let botTaskId: Int
    }
}

// MARK: - Text
struct Text: Decodable {
    let text, type: String
}

// MARK: - Message
struct Message: Decodable {
    let message, createdAt: String
}

// MARK: - QuickAction
struct QuickAction: Decodable {
    let buttonTitle: String
    let botTaskId: Int
}
