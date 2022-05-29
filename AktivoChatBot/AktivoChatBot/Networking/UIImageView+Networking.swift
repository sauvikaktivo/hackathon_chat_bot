//
//  UIImageView+Networking.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit
import Combine

var imageCache: [String: UIImage] = [:]
var disposeBag = Set<AnyCancellable>()

extension UIImageView {
    func loadImage(url: String) {
        if let image = imageCache[url] {
            self.image = image
            return
        }
        return URLSession.shared.dataTaskPublisher(for: URL(string: baseUrl)!.appendingPathComponent(url))
            .sink { state in
                switch state {
                case .finished:
                    break
                case .failure(let error):
                    print("Image load failed from URL: \(url) error: \(error)")
                }
            } receiveValue: { result in
                DispatchQueue.main.async {
                    imageCache[url] = UIImage(data: result.data)
                    self.image = imageCache[url]
                }
            }.store(in: &disposeBag)
    }
}

