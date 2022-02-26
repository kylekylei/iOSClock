//
//  StopwatchViewController.swift
//  iOSClock
//
//  Created by Kyle Lei on 2022/1/27.
//

import UIKit

class StopwatchViewController: UIViewController {
    private var digitViewController: DigitViewController?
    private var analogViewController:  AnalogViewController?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var lapTimerView: UIView! {
        didSet {
            let thickness: CGFloat = 1
            let inset: CGFloat = 20
            let topBorder = CALayer()
            let bottomBorder = CALayer()
            topBorder.frame = CGRect(x: inset, y: 0, width: lapTimerView.frame.width - inset * 2, height: thickness)
            bottomBorder.frame = CGRect(x: inset, y: lapTimerView.frame.height - thickness, width: lapTimerView.frame.width - inset * 2, height: thickness)
            topBorder.backgroundColor = UIColor.systemGray6.cgColor
            bottomBorder.backgroundColor = UIColor.systemGray6.cgColor
            lapTimerView.layer.addSublayer(topBorder)
            lapTimerView.layer.addSublayer(bottomBorder)
        }
    }
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var watchContainer: [UIView]!
    @IBOutlet weak var containerIndicator: UIPageControl!
    @IBOutlet weak var stopWatchScrollView: UIScrollView!

    
    var isReset = true {
        didSet { updateUI() }
    }
    var isRunning = false {
        didSet { updateUI() }
    }
    var mainStartTime: Date?
    var mainTimeInterval: TimeInterval = 0 //按下開始到目前的時間差
    var mainRestingTimeeInterval: TimeInterval = 0 //按下暫停到開始的時間差
    var mainTimeString: String {
        if #available(iOS 15, *) {
            let minute = (Int(mainTimeInterval) / 60).formatted(.number.precision(.integerLength(2)))
            let second = (Int(mainTimeInterval) % 60).formatted(.number.precision(.integerLength(2)))
            let milliseconds = (Int(mainTimeInterval * 100) % 100 ).formatted(.number.precision(.integerLength(2)))
            return "\(minute):\(second).\(milliseconds)"
        } else {
            let minute = String(format: "%02d", Int(mainTimeInterval)  / 60)
            let second = String(format: "%02d", Int(mainTimeInterval) % 60)
            let milliseconds = String(format: "%02d", Int(mainTimeInterval * 100) % 100)
            return "\(minute):\(second).\(milliseconds)"
        }
    }
    
    
    var laps = [Lap]()
    var lapStartTime: Date?
    var lapTimeInterval: TimeInterval = 0
    var lapRestingTimeeInterval: TimeInterval = 0
    var lapTimeString: String {
        if #available(iOS 15, *) {
            let minute = (Int(lapTimeInterval) / 60).formatted(.number.precision(.integerLength(2)))
            let second = (Int(lapTimeInterval) % 60).formatted(.number.precision(.integerLength(2)))
            let milliseconds = (Int(lapTimeInterval * 100) % 100).formatted(.number.precision(.integerLength(2)))
            return "\(minute):\(second).\(milliseconds)"
        } else {
            let minute = String(format: "%.2d", Int(lapTimeInterval) / 60)
            let second = String(format: "%.2d", Int(lapTimeInterval) % 60)
            let millisecond = String(format: "%.2d", Int(lapTimeInterval * 100) % 100)
            return "\(minute):\(second).\(millisecond)"
        }
    }
    
    var timer = Timer() {
        didSet {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    var lapIndex = 1

    
    var maxLapTime: TimeInterval = 0
    var minLapTime: TimeInterval = TimeInterval(Int.max)
    var pageNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        if let laps = Lap.loadLaps() {
            self.laps = laps
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        stopWatchScrollView.delegate = self
        
        updateUI()
    }
    
    @IBAction func toggleStopwatch(_ sender: UIButton) {
        isRunning ? stop(): start()
    }
    
    @IBAction func lapOrReset(_ sender: Any) {
        isRunning ? setLap() : reset()
    }
    
    
    func updateUI() {
        lapTimerView.isHidden = isReset ? true : false
        
        triggerButton.configurationUpdateHandler = { button in
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = AttributedString(self.isRunning ? SetTitle.Stop.rawValue : SetTitle.Start.rawValue)
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = self.isRunning ? UIColor.lightRed : UIColor.lightGreen
            configuration.baseBackgroundColor = self.isRunning ?  UIColor.darkRed : UIColor.darkGreen
            configuration.background.strokeWidth = 2
            configuration.background.strokeColor = self.isRunning ? UIColor.darkRed : UIColor.darkGreen
            configuration.background.strokeOutset = 5
            
            button.configuration = configuration
            button.alpha = button.isHighlighted ? 0.5 : 1
        }
        
        lapButton.configurationUpdateHandler = { button in
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = self.isReset ? AttributedString(SetTitle.Lap.rawValue ) : AttributedString(self.isRunning ? SetTitle.Lap.rawValue : SetTitle.Reset.rawValue)
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = UIColor.lightGray
            configuration.baseBackgroundColor = UIColor.darkGray
            configuration.background.strokeWidth = 2
            configuration.background.strokeColor = UIColor.darkGray
            configuration.background.strokeOutset = 5
            
            button.configuration = configuration
            button.alpha = button.isHighlighted ? 0.5 : 1
            button.isEnabled = self.isReset ? false : true
        }
    }

    
    func start() {
        isReset = false
        isRunning = true
        
        mainStartTime = Date()
        lapStartTime = Date()
        lapLabel.text = "Lap \(lapIndex)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true, block: { [self](_) in
            mainTimeInterval = -(mainStartTime?.timeIntervalSinceNow ?? 0) + mainRestingTimeeInterval
            digitViewController?.digitTimeLabel.text = mainTimeString
            
            analogViewController?.digitTimeLabel.text = mainTimeString
            analogViewController?.mainTimeInterval = mainTimeInterval
            analogViewController?.lapTimeInterval = lapTimeInterval
            analogViewController?.lapWatchView.isHidden = laps.isEmpty ? true : false
            
            lapTimeInterval = -(lapStartTime?.timeIntervalSinceNow ?? 0) + lapRestingTimeeInterval
            timeLabel.text = lapTimeString
            
        })
    }

    
    func stop() {
        
        mainRestingTimeeInterval = mainRestingTimeeInterval + Date().timeIntervalSince(mainStartTime ?? Date())
        lapRestingTimeeInterval = lapRestingTimeeInterval + Date().timeIntervalSince(lapStartTime ?? Date())//
        isRunning = false
        timer.invalidate()
    }
    
    func reset() {
        isReset = true
        isRunning = false
        
        mainStartTime = nil
        mainTimeInterval = 0
        mainRestingTimeeInterval = 0
        lapStartTime = nil
        lapTimeInterval = 0
        lapRestingTimeeInterval = 0
        
        lapIndex = 1
        digitViewController?.digitTimeLabel.text = "00:00.00"
        analogViewController?.mainTimeInterval = 0
        analogViewController?.lapTimeInterval = 0
        
        laps.removeAll()
        tableView.reloadData()
    }
    
    func setLap(){
        lapStartTime = Date()
        lapRestingTimeeInterval = 0
        laps.insert(Lap(lapIndex: lapIndex, lapTimeString: lapTimeString, lapTime: lapTimeInterval), at: 0)
        lapIndex += 1
        lapLabel.text = "Lap \(lapIndex)"
        tableView.reloadData()
        
        maxLapTime = lapTimeInterval > maxLapTime ? lapTimeInterval : maxLapTime
        minLapTime = lapTimeInterval < minLapTime ? lapTimeInterval : minLapTime
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "digitTimeSegue", let controller = segue.destination as? DigitViewController {
            digitViewController = controller
        }
        if  segue.identifier == "analogTimeSegue", let controller = segue.destination as? AnalogViewController {
            analogViewController = controller
            analogViewController?.center = CGPoint(x: stopWatchScrollView.bounds.midX, y: stopWatchScrollView.bounds.midY)
            
        }
        
    }    


}

extension StopwatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StopwatchTableViewCell.self)", for: indexPath) as! StopwatchTableViewCell
        let lap = laps[indexPath.row]
            cell.lapLabel.text = "Lap \(lap.lapIndex)"
            cell.timeLabel.text = lap.lapTimeString
        
        if laps.count > 1 {
            if lap.lapTime >= maxLapTime {
                cell.lapLabel.textColor = .lightRed
                cell.timeLabel.textColor = .lightRed
            }else if lap.lapTime <= minLapTime {
                cell.lapLabel.textColor = .lightGreen
                cell.timeLabel.textColor = .lightGreen
            }else {
                cell.lapLabel.textColor = .white
                cell.timeLabel.textColor = .white
            }
        }
        return cell
    }
    
    
    
}

extension StopwatchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageNumber = Int(stopWatchScrollView.contentOffset.x / stopWatchScrollView.bounds.size.width)
        containerIndicator.currentPage = pageNumber
    }
}

