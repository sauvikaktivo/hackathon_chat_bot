//
//  ChatMessageComposeView.swift
//  AktivoChatBot
//
//  Created by Sauvik Dolui on 30/05/22.
//

import UIKit

protocol ChatMessageComposeViewDelegate: AnyObject {
    func chatMessageComposer(_ view: ChatMessageComposeView, didTapSendButton button: UIButton)
}
final class ChatMessageComposeView: UIView {
    weak var delegate: ChatMessageComposeViewDelegate?
    lazy var textField: UITextField = {
        let f = UITextField()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.placeholder = "Type something (max 140 char)"
        f.delegate = self
        return f
    }()
    lazy var sendButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isEnabled = false
        b.setImage(UIImage(named: "send_disabled"), for: .disabled)
        b.setImage(UIImage(named: "send_active"), for: .normal)
        b.addTarget(self, action: #selector(actionSendButton(_:)), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("Init code not implemented")
    }
    @objc
    func actionSendButton(_ sender: Any) {
        delegate?.chatMessageComposer(self, didTapSendButton: sendButton)
    }
    func reset() {
        textField.resignFirstResponder()
        textField.text = nil
        sendButton.isEnabled = false
    }
}

extension ChatMessageComposeView {
    private func setupUI() {
        addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 12),
            textField.heightAnchor.constraint(equalToConstant: 26),
            textField.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
        ])
    }
}
extension ChatMessageComposeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        sendButton.isEnabled = finalText?.count ?? 0 > 0
        return true
    }
}
