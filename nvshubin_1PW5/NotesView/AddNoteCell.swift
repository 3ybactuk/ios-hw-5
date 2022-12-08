//
//  AddNoteCell.swift
//  nvshubin_1PW4
//
//  Created by Nikita on 20.11.2022.
//

import UIKit

final class AddNoteCell: UITableViewCell {
    static let reuseIdentifier = "AddNoteCell"
    private var textView = UITextView()
    var placeholderLabel : UILabel!
    
    public var addButton = UIButton()
    
    var delegate: AddNoteDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type smth..."
        placeholderLabel.font = .systemFont(ofSize: 14, weight: .regular)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 7)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.setHeight(140)
        

        addButton.setTitle("Add new note", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.setTitleColor(.systemBackground, for: .normal)
        addButton.backgroundColor = .label
        addButton.layer.cornerRadius = 8
        addButton.setHeight(44)
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)

        addButton.alpha = 0.9
        
        let stackView = UIStackView(arrangedSubviews: [textView, addButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.pin(to: contentView, [.left, .top, .right, .bottom], 16)
        
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 12
    }
    
    @objc
    private func addButtonTapped(_ sender: UIButton) {
        if (!textView.text.isEmpty) {
            self.delegate?.newNoteAdded(note: ShortNote(text: textView.text))
            textView.text = ""
            textViewDidChange(textView)
        }
    }
}

extension AddNoteCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
