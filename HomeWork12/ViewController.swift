//
//  ViewController.swift
//  HomeWork12
//
//  Created by Kaiten Aiko on 22.02.2024.
//

import UIKit

class ViewController: UIViewController {

// MARK: Объекты приложения
    
// Надпись сверху экрана
    
    let simpleLabel: UILabel = {
        let label = UILabel()
        label.text = "Time to Try"
        label.font = UIFont.boldSystemFont(ofSize: 64)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
// Таймер

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.boldSystemFont(ofSize: 84)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var timer = Timer()
    var durationTimer = 10
    var isCounting = false
    
// Кнопка
    
    let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("PLAY", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
// Массив, хранящий цвета
    
    let colors: [UIColor] = [.green, .red]
    var currentColorIndex = 1

// Обводка progress bar
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 21
        layer.strokeColor = colors[currentColorIndex].cgColor
        layer.strokeEnd = 1
        return layer
    }()
    
// MARK: Методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Установка фона
        
        let backgroundImage = UIImage(named: "background sky")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.isOpaque = false
        
// Вызов ограничений
        
        setConstraints()
        
// Нажатие кнопки
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
// Таймер
    
    @objc func activateTimer() {
        
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)"
        
        if durationTimer == 0 {
            currentColorIndex = (currentColorIndex + 1) % colors.count
            shapeLayer.strokeColor = colors[currentColorIndex].cgColor
            durationTimer = isCounting ? 10 : 5
            isCounting.toggle()
            animateCircle(TimeInterval(durationTimer))
            timerLabel.text = "\(durationTimer)"
        }
    }
    
// Нажатие кнопки и анимация
    
    @objc func startButtonTapped() {
        if timer.isValid {
            timer.invalidate()
            startButton.setTitle("PLAY", for: .normal)
            shapeLayer.removeAllAnimations()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(activateTimer), userInfo: nil, repeats: true)
            startButton.setTitle("PAUSE", for: .normal)
            animateCircle(TimeInterval(durationTimer))
        }
    }
    
// Анимация progress bar
    
    func animateCircle(_ duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animateCircle")
    }
    
// Установка ограничений
    
    func setConstraints() {
        
        view.addSubview(simpleLabel)
        NSLayoutConstraint.activate([
            simpleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            simpleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            simpleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.layer.addSublayer(shapeLayer)
        shapeLayer.path = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false).cgPath
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 100),
            timerLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 70),
            startButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
