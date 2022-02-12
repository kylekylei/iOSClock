//
//  TimerViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/2/8.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var progressView: UIView! {
        didSet {
            progressView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var cacelButton: UIButton!
    @IBOutlet weak var digitalTimerLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var isReset = true {
        didSet { updateUI() }
    }
    var isRunning = false {
        didSet { updateUI() }
    }
    

    let numbersOf24 = [Int](0...23)
    let numbersOf60 = [Int](0...59)
    var hour = 0
    var minute = 0
    var second = 0
    var timeInterval: Int {
        hour * 3600 + minute * 60 + second
    }
    var countdownInterval: Double = 0
    var resumeInterval: Double = 0
    var endTime = Date()
    
    var timer = Timer() {
        didSet {
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    var center: CGPoint {
        CGPoint(x: progressView.center.x, y: progressView.center.y - 50)
    }
    var radius: CGFloat {
        center.x - 15
    }
    
    let progressBar: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = 10
        shape.strokeColor  = UIColor.cyan.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        return shape
    }()
    
    var uuidString = ""
 
    
    func createNotificationNow() {
        let content = UNMutableNotificationContent()
        content.title = "K Clock"
        content.body = "Timer"
        content.sound = UNNotificationSound.default
        
        uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: "notificationByTimer", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in

        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        timePicker.delegate = self
        timePicker.dataSource = self
        

        let progressBG: CAShapeLayer = {
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(360).degree, clockwise: true)
            let shape = CAShapeLayer()
            shape.path = path.cgPath
            shape.strokeColor = UIColor.darkGray.cgColor
            shape.lineWidth = 10
            shape.fillColor = UIColor.clear.cgColor
            return shape
        }()
        progressView.layer.addSublayer(progressBG)
        progressView.layer.addSublayer(progressBar)
       

    }
    
    
    @IBAction func toggleTimer(_ sender: UIButton) {
        isRunning ? pause() : timeInterval == 0 ? nil : start()
    }
    
    @IBAction func cancelTimer(_ sender: UIButton) {
        isReset ? nil : cancel()
    }
    
    func updateUI() {
        timePickerView.isHidden = isReset ? false : true
        progressView.isHidden = isReset ? true : false
        
        triggerButton.configurationUpdateHandler = { button in
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = AttributedString(self.isReset ? SetTitle.Start.rawValue : self.isRunning ? SetTitle.Pause.rawValue : SetTitle.Resume.rawValue)
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = self.isReset ? .lightGreen : self.isRunning ? .lightCyan : .lightGreen
            configuration.baseBackgroundColor = self.isReset ? .blackGreen : self.isRunning ? .darkCyan : .darkGreen
            configuration.background.strokeWidth = 2
            configuration.background.strokeColor = self.isReset ? .blackGreen : self.isRunning ? .darkCyan : .darkGreen
            configuration.background.strokeOutset = 5
            
            
            button.configuration = configuration
            button.alpha = button.isHighlighted ? 0.5 : 1
            
        }
        
        cacelButton.configurationUpdateHandler = { button in
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = AttributedString(SetTitle.Cancel.rawValue)
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = .lightGray
            configuration.baseBackgroundColor = .darkGray
            configuration.background.strokeWidth = 2
            configuration.background.strokeColor = .darkGray
            configuration.background.strokeOutset = 5
            
            button.configuration = configuration
            button.alpha = button.isHighlighted ? 0.5 : 1
            button.isEnabled = self.isReset ? false : true
        }
    }
    
    func start() {
        countdownInterval = isReset ? Double(timeInterval) : Double(resumeInterval)
        isReset = false
        isRunning = true
        
        endTimeLabel.text = setEndTime()
        
        
        let startAngle: CGFloat = 270
        let perAngle = CGFloat(360 / timeInterval)
        var currentAngle: CGFloat = 360


        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self](_) in
            let countdownStr:String = {
                let hour = (Int(countdownInterval) / 3600).formatted(.number.precision(.integerLength(2)))
                let minute = ((Int(countdownInterval) % 3600) / 60).formatted(.number.precision(.integerLength(2)))
                let second = (Int(countdownInterval) % 60).formatted(.number.precision(.integerLength(2)))
                return Int(hour) == 0 ? "\(minute):\(second)" : "\(hour):\(minute):\(second)"
            }()
            digitalTimerLabel.text = countdownStr
            
            currentAngle = startAngle + CGFloat(countdownInterval) * perAngle
            let path = UIBezierPath()
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle.degree, endAngle: currentAngle.degree, clockwise: true)
            progressBar.path = path.cgPath
            
            countdownInterval -= 0.01
            
            if countdownInterval < 0 {
                createNotificationNow()
                cancel()
            }
        })
        timer.fire()
   

    }
    
    func pause() {
        timer.invalidate()
        isRunning = false
        resumeInterval = countdownInterval
    }
    
    func cancel() {
        timer.invalidate()
        isReset = true
        isRunning = false

    }
    
    func setEndTime() -> String {
        let endTimeInterval: TimeInterval = TimeInterval(timeInterval) + Date().timeIntervalSince1970
        endTime = Date(timeIntervalSince1970: endTimeInterval)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: endTime)
    }
    
}

extension TimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return numbersOf24.count
        case 2: return numbersOf60.count
        case 4: return numbersOf60.count
        default: return 1
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return numbersOf24[row].description
        case 1:
            let hour = UILabel()
            hour.text = "hours"
            timePicker.setPickerLabelSize(labels: [1 : hour])
            return ""
        case 2: return numbersOf60[row].description
        case 3:
            let min = UILabel()
            min.text = "min"
            timePicker.setPickerLabelSize(labels: [3 : min])
            return ""
        case 4: return numbersOf60[row].description
        case 5:
            let sec = UILabel()
            sec.text = "sec"
            timePicker.setPickerLabelSize(labels: [5 : sec])
            return ""
        default: return "error"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: hour = numbersOf24[row]
        case 2: minute = numbersOf60[row]
        case 4: second = numbersOf60[row]
        default: return
        }
    }
}

extension UIPickerView {
    func setPickerLabelSize(labels: [Int: UILabel]) {
        let fontSize: CGFloat = 20
        let labelWidth: CGFloat = self.frame.width / CGFloat(self.numberOfComponents)
        let y: CGFloat = (self.frame.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            if let label = labels[i] {
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.left
                self.addSubview(label)
            }
        }
    }
}
