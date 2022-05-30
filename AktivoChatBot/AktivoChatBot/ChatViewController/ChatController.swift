//
//  ChatController.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import Foundation

class ChatController {
    var sections: [ChatBotSection] = []
    
    func sectionType(sectionIndex: Int) -> ChatBotSection? {
        guard sectionIndex < sections.count else { return nil }
        return sections[sectionIndex]
    }
}
