//
//  AppDelegate.swift
//  nvshubin_1PW3
//
//  Created by Nikita on 29.10.2022.
//

import UIKit

class ViewController: UIViewController {
    private let commentLabel = UILabel()
    private let valueLabel = UILabel()
    private let incrementButton = UIButton(type: .system)
    
    private var buttonsSV = UIStackView()
    private var value: Int = 0
    
    let colorPaletteView = ColorPaletteView()
    
    var bgColor: UIColor = .systemGray6 {
        didSet {
            view.backgroundColor = bgColor
            colorPaletteView.setSliders(color: bgColor)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.colorPaletteView.viewControllerDelegate = self
        bgColor = .systemGray6
        
        setupIncrementButton()
        setupValueLabel()
        setupCommentView()
        buttonsSV = setupMenuButtons()
        setupColorControlSV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupColorControlSV() {
        colorPaletteView.isHidden = true
        colorPaletteView.layer.applyShadow(2.0)
        view.addSubview(colorPaletteView)

        colorPaletteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                colorPaletteView.topAnchor.constraint(equalTo: incrementButton.bottomAnchor, constant: 8),
                                colorPaletteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                                colorPaletteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                                colorPaletteView.bottomAnchor.constraint(equalTo: buttonsSV.topAnchor, constant: -8)])
    }

    private func setupIncrementButton() {
        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.layer.cornerRadius = 12
        incrementButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        incrementButton.backgroundColor = .white
        incrementButton.layer.applyShadow(2.0)
        self.view.addSubview(incrementButton)
        incrementButton.setHeight(48)
        incrementButton.pinTop(to: self.view.centerYAnchor)
        incrementButton.pin(to: self.view, [.left, .right], 24)
        
        incrementButton.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
    }
    
    private func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: 40.0, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.text = "\(value)"
        
        self.view.addSubview(valueLabel)
        
        valueLabel.pinCenterX(to: self.view.centerXAnchor)
        valueLabel.pinCenterY(to: self.view.centerYAnchor, -64)
    }
    
    @discardableResult
    private func setupCommentView() -> UIView {
        let commentView = UIView()
        commentView.backgroundColor = .white
        commentView.layer.cornerRadius = 12
        view.addSubview(commentView)
        commentView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        commentView.pin(to: self.view, [.left, .right], 24)
        commentView.setHeight(48)
        commentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        commentLabel.textColor = .systemGray
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .center
        commentView.addSubview(commentLabel)
        commentLabel.pin(to: commentView, [.top, .left, .bottom, .right], 16)
        return commentView
    }
    
    func updateCommentLabel(value: Int) {
        switch value {
            case 0...10:
                commentLabel.text = "1"
            case 10...20:
                commentLabel.text = "2"
            case 20...30:
                commentLabel.text = "3"
            case 30...40:
                commentLabel.text = "4"
            case 40...50:
                commentLabel.text = "! ! ! ! ! ! ! ! ! "
            case 50...60:
                commentLabel.text = "big boy"
            case 60...70:
                commentLabel.text = "70 70 70 moreeeee"
            case 70...80:
                commentLabel.text = "⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️"
            case 80...90:
                commentLabel.text = "80+\n go higher!"
            case 90...100:
                commentLabel.text = "100!! to the moon!!"
            default:
                break
        }
    }
    
    @objc
    private func incrementButtonPressed() {
        value += 1
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if (value % 10 == 1) {
            UIView.transition(with: self.commentLabel,
                              duration: 1,
                              options: [.transitionCrossDissolve],
                              animations: { self.updateCommentLabel(value: self.value) }
            )
        }
        self.setupValueLabel()
    }
    
    @objc
    private func paletteButtonPressed() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.transition(with: self.colorPaletteView,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: { self.colorPaletteView.isHidden.toggle() }
        )
    }
    
    @objc
    private func noteButtonPressed() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let nav = UINavigationController(rootViewController: NotesViewController())
        nav.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc
    private func newsButtonPressed() {
        let newsListController = NewsListViewController()
//        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(newsListController, animated: true)
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        return button
    }
    
    private func setupMenuButtons() -> UIStackView {
        let colorsButton = makeMenuButton(title: "🎨")
        colorsButton.addTarget(self, action: #selector(paletteButtonPressed), for: .touchUpInside)

        let notesButton = makeMenuButton(title: "📝")
        notesButton.addTarget(self, action: #selector(noteButtonPressed), for: .touchUpInside)
        
        let newsButton = makeMenuButton(title: "📰")
        newsButton.addTarget(self, action: #selector(newsButtonPressed), for: .touchUpInside)
        
        let buttonsSV = UIStackView(arrangedSubviews: [colorsButton, notesButton, newsButton])
        
        buttonsSV.layer.applyShadow(2.0)
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually
        self.view.addSubview(buttonsSV)
        buttonsSV.pin(to: self.view, [.left, .right], 24)
        buttonsSV.pinBottom(to: self.view, 24)
        
        return buttonsSV
    }
}

protocol ViewControllerColorDelegate {
    func changeColor(_ slider: ColorPaletteView)
}

extension ViewController: ViewControllerColorDelegate {
    @objc
    func changeColor(_ slider: ColorPaletteView) {
        UIView.animate(withDuration: 0.5) {
            self.bgColor = slider.chosenColor
        }
    }
}
