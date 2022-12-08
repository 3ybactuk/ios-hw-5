//
//  ColorPallete.swift
//  nvshubin_1PW3
//
//  Created by Nikita on 30.10.2022.
//

import UIKit


final class ColorPaletteView: UIControl {
    private let stackView = UIStackView()
    private(set) var chosenColor: UIColor = .systemGray6
    
    var viewControllerDelegate: ViewControllerColorDelegate?
    
    private let redControl = ColorSliderView(colorName: "R", value: 0)
    private let greenControl = ColorSliderView(colorName: "G", value: 0)
    private let blueControl = ColorSliderView(colorName: "B", value: 0)
    
    init() {
        super.init(frame: .zero)
        
        viewControllerDelegate?.changeColor(self)
        setupView()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        redControl.changeValue(Float(chosenColor.redComponent))
        greenControl.changeValue(Float(chosenColor.greenComponent))
        blueControl.changeValue(Float(chosenColor.blueComponent))
        redControl.tag = 0
        greenControl.tag = 1
        blueControl.tag = 2
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(redControl)
        stackView.addArrangedSubview(greenControl)
        stackView.addArrangedSubview(blueControl)
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        
        [redControl, greenControl, blueControl].forEach {
            ($0 as AnyObject).addTarget(self, action: #selector(sliderMoved(slider:)), for: .touchDragInside)
        }
        
        addSubview(stackView)
        stackView.pin(to: self, [.left, .right, .top, .bottom])
    }
    
    @objc
    private func updateSlider(slider: ColorSliderView) {
        switch slider.tag {
        case 0:
            slider.changeValue(Float(chosenColor.redComponent))
        case 1:
            slider.changeValue(Float(chosenColor.greenComponent))
        default:
            slider.changeValue(Float(chosenColor.blueComponent))
        }
    }
    
    func setSliders(color: UIColor) {
        chosenColor = color
        
        updateSlider(slider: redControl)
        updateSlider(slider: greenControl)
        updateSlider(slider: blueControl)
    }
    
    @objc
    private func sliderMoved(slider: ColorSliderView) {
        switch slider.tag {
        case 0:
            self.chosenColor = UIColor(
                red: CGFloat(slider.value),
                green: chosenColor.greenComponent,
                blue: chosenColor.blueComponent,
                alpha: chosenColor.alphaComponent
            )
        case 1:
            self.chosenColor = UIColor(
                red: chosenColor.redComponent,
                green: CGFloat(slider.value),
                blue: chosenColor.blueComponent,
                alpha: chosenColor.alphaComponent
            )
        default:
            self.chosenColor = UIColor(
                red: chosenColor.redComponent,
                green: chosenColor.greenComponent,
                blue: CGFloat(slider.value),
                alpha: chosenColor.alphaComponent
            )
        }
        viewControllerDelegate?.changeColor(self)
        sendActions(for: .touchDragInside)
    }
}

extension ColorPaletteView {
    final class ColorSliderView: UIControl {
        private let slider = UISlider()
        private let colorLabel = UILabel()
        private(set) var value: Float
        
        init(colorName: String, value: Float) {
            self.value = value
            super.init(frame: .zero)
            slider.value = value
            colorLabel.text = colorName
            setupView()
            slider.addTarget(self, action:
                                #selector(sliderMoved(_:)), for: .touchDragInside)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func changeValue(_ val: Float) {
            self.slider.setValue(val, animated: true)
        }
        
        private func setupView() {
            let stackView = UIStackView(arrangedSubviews: [colorLabel, slider])
            stackView.axis = .horizontal
            stackView.spacing = 8
            addSubview(stackView)
            stackView.pin(to: self, [.left, .top, .right, .bottom], 12)
        }
        
        @objc
        private func sliderMoved(_ slider: UISlider) {
            self.value = slider.value
            sendActions(for: .touchDragInside)
        }
    }
}
