//
//  AnalogViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/2/6.
//

import UIKit

class AnalogViewController: UIViewController {

    @IBOutlet weak var digitTimeLabel: UILabel!
    var center: CGPoint?
    lazy var radius: CGFloat = center!.x - 10
    lazy var centerX = center!.x
    lazy var centerY = center!.y
    lazy var centerY2 = centerY - 64
    let minuteRadius: CGFloat = 50
       
    var mainTimeInterval: TimeInterval = 0 {
        didSet {
            let secondAngle = CGFloat(mainTimeInterval.truncatingRemainder(dividingBy: 60) * 6)
            mainSecondWatchView.transform = CGAffineTransform.identity.rotated(by: secondAngle.degree)
            
            let minuteAngle = CGFloat(mainTimeInterval / 60 * 6)
            mainMinuteWatchView.transform = CGAffineTransform.identity.rotated(by: minuteAngle.degree)
        }
    }
    var lapTimeInterval: TimeInterval = 0 {
        didSet {
            let secondAngle = CGFloat(lapTimeInterval.truncatingRemainder(dividingBy: 60) * 6)
            lapWatchView.transform = CGAffineTransform.identity.rotated(by: secondAngle.degree)
        }
    }
    
    
    var secondLabels: [String] {
        var labels = [String]()
        for i in stride(from: 5, through: 60, by: 5) {
            labels.append(String(i))
        }
        return labels
    }
    var minuteLabels: [String] {
        var labels = [String]()
        for i in stride(from: 5, through: 30, by: 5) {
            labels.append(String(i))
        }
        return labels
    }
    

    let mainSecondWatchView = UIView()
    let lapWatchView = UIView()
    let mainMinuteWatchView  = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        lapWatchView.isHidden = true

        let minutePointer: CAShapeLayer = {
            let shape = CAShapeLayer()
            let line: CAShapeLayer = {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: minuteRadius, y: minuteRadius))
                path.addLine(to: CGPoint(x: minuteRadius, y: 0))
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.lineWidth = 2
                shape.strokeColor = UIColor.cyan.cgColor
                return shape
            }()
            
            let dot: CAShapeLayer = {
                let path = UIBezierPath(arcCenter: CGPoint(x: minuteRadius, y: minuteRadius), radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.fillColor = UIColor.cyan.cgColor
                return shape
            }()
          
            shape.addSublayer(line)
            shape.addSublayer(dot)
            return shape
        }()
        
        mainMinuteWatchView.layer.addSublayer(minutePointer)
        mainMinuteWatchView.frame = CGRect(x: centerX - minuteRadius, y: centerY2 - minuteRadius, width: minuteRadius * 2, height: minuteRadius * 2)
        view.addSubview(mainMinuteWatchView)
        
        
        let secondWatchBG: UIView = {
            let view = UIView()
            
            let oneIntervalPoint: CGFloat = radius - 10
            let fiveIntrtvalPoint: CGFloat = radius - 20
            for angle in stride(from: CGFloat(0), to: CGFloat(360), by: CGFloat(1.5)) {
                let point = angle.truncatingRemainder(dividingBy: 6) == 0 ? fiveIntrtvalPoint : oneIntervalPoint
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: centerX + point * cos(angle.degree) , y: centerY - point * sin(angle.degree) ))
                path.addLine(to: CGPoint(x: centerX + radius * cos(angle.degree), y: centerY - radius * sin(angle.degree)))
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.lineWidth = 3
                shape.strokeColor = angle.truncatingRemainder(dividingBy: 30) == 0 ? UIColor.white.cgColor : UIColor.darkGray.cgColor
                view.layer.addSublayer(shape)
            }
            
            let fontSize: CGFloat = 32
            let startAngle: CGFloat = 270
            let secondLabelRadius = radius - 48
            for (index, secondLabel) in secondLabels.enumerated() {
                let currentAngle: CGFloat = startAngle + CGFloat(index + 1) * 30
                let textLayer = CATextLayer()
                let x: CGFloat = centerX + secondLabelRadius * cos(currentAngle.degree) - CGFloat(fontSize / 2) - 4
                let y: CGFloat = centerY + secondLabelRadius * sin(currentAngle.degree) - CGFloat(fontSize / 2) - 4
                
                textLayer.frame = CGRect(x: x, y: y, width: fontSize + 8, height: fontSize)
                textLayer.fontSize = fontSize
                textLayer.foregroundColor = UIColor.white.cgColor
                textLayer.alignmentMode = .center
                textLayer.string = String(secondLabel)
                view.layer.addSublayer(textLayer)
            }
            return view
        }()
        view.addSubview(secondWatchBG)
   
        lapWatchView.layer.addSublayer(secodPointer(color: UIColor.yellow, hasDot: false))
        lapWatchView.frame = CGRect(x: 0 ,y: 0, width: center!.x * 2, height: center!.x * 2)
        view.addSubview(lapWatchView)
       
        mainSecondWatchView.layer.addSublayer(secodPointer(color: UIColor.cyan, hasDot: true))
        mainSecondWatchView.frame = lapWatchView.frame
        view.addSubview(mainSecondWatchView)
        
        let minuteWatcgBG: UIView = {
            let view = UIView()
            
            let oneIntervalPoint: CGFloat = minuteRadius - 6
            let fiveIntrtvalPoint: CGFloat = minuteRadius - 12
            for angle in stride(from: CGFloat(0), to: CGFloat(360), by: CGFloat(6)) {
                
                let point = (angle + 6).truncatingRemainder(dividingBy: 12) == 0 ? fiveIntrtvalPoint : oneIntervalPoint
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: centerX + point * cos(angle.degree), y: centerY2 - point * sin(angle.degree)))
                path.addLine(to: CGPoint(x: centerX + minuteRadius * cos(angle.degree), y: centerY2 - minuteRadius * sin(angle.degree)))
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.lineWidth = 2
                shape.strokeColor = (angle + 30).truncatingRemainder(dividingBy: 60) == 0 ? UIColor.white.cgColor : UIColor.darkGray.cgColor
                view.layer.addSublayer(shape)
            }
            
            let fontSize: CGFloat = 14
            let startAngle: CGFloat = 270
            let secondLabelRadius = minuteRadius - 24
            for (index, minuteLabel) in minuteLabels.enumerated() {
                let currentAngle: CGFloat = startAngle + CGFloat(index + 1) * 60
                let textLayer = CATextLayer()
                let x: CGFloat = centerX + secondLabelRadius * cos(currentAngle.degree) - CGFloat(fontSize / 2) - 4
                let y: CGFloat = centerY2 + secondLabelRadius * sin(currentAngle.degree) - CGFloat(fontSize / 2) - 4
                
                textLayer.frame = CGRect(x: x, y: y, width: fontSize + 8, height: fontSize)
                textLayer.fontSize = fontSize
                textLayer.foregroundColor = UIColor.white.cgColor
                textLayer.alignmentMode = .center
                textLayer.string = String(minuteLabel)
                view.layer.addSublayer(textLayer)
            }
            
            return view
        }()
        view.addSubview(minuteWatcgBG)
        
        func secodPointer(color: UIColor, hasDot: Bool) -> CAShapeLayer {
            let path = UIBezierPath()
            let tailingLength: CGFloat = 40
            path.move(to: CGPoint(x: centerX, y: centerY + tailingLength))
            path.addLine(to: CGPoint(x: centerX, y: centerY - radius))
            let shape = CAShapeLayer()
            shape.path = path.cgPath
            shape.lineWidth = 3
            shape.strokeColor = color.cgColor
            shape.fillColor = UIColor.clear.cgColor
            
            if hasDot {
                let circleShape: CAShapeLayer = {
                    let path = UIBezierPath(arcCenter: center!, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                    let shape = CAShapeLayer()
                    shape.path = path.cgPath
                    shape.lineWidth = 3
                    shape.strokeColor = UIColor.cyan.cgColor
                    shape.fillColor = UIColor.black.cgColor
                    return  shape
                }()
                shape.addSublayer(circleShape)
            }
            return  shape
        }

    }
    
}

