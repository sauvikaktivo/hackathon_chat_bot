//
//  BotChatViewController.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit
import Combine

class BotChatViewController: UIViewController {

    private lazy var disposables = Set<AnyCancellable>()
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLayout()
        
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
                self.imageView.loadImage(url: result.layout!.layout!.grid.items.first!.imageUrl)
            }).store(in: &disposables)
    }
    
    func configLayout() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
