//
//  ViewController.swift
//  Timer
//
//  Created by Raúl González on 17/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var aceptarButton: UIButton!
    @IBOutlet weak var cancelarButton: UIButton!
    
    var countingVar:Bool = false
    var initialTime:Date?
    var finalTime:Date?
    var setTimer:Timer!
    
    let userDefaults = UserDefaults.standard
    let initialTimeKey = "initialTime"
    let finalTimeKey = "finalTime"
    let countingKey = "countingKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialTime = userDefaults.object(forKey: initialTimeKey) as? Date
        finalTime = userDefaults.object(forKey: finalTimeKey) as? Date
        countingVar = userDefaults.bool(forKey: countingKey)
        
        if countingVar{
            initialTimer()
        }else{
            finalTimer()
            if let start = initialTime{
                if let stop = finalTime{
                    let time = calcResTimer(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimerLabel(Int(diff))
                }
            }
        }
    }
    
    @IBAction func aceptarAction(_ sender: Any) {
        if countingVar{
            finalTimeSet(date: Date())
            finalTimer()
        }else{
            if let stop = finalTime{
                let restartTimer = calcResTimer(start: initialTime!, stop: stop)
                finalTimeSet(date: nil)
                initialTimeSet(date: restartTimer)
            }else{
                initialTimeSet(date: Date()) 
            }
            initialTimer()
        }
    }
    
    func calcResTimer(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func initialTimer(){
        setTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshVal), userInfo: nil, repeats: true)
        countingSet(true)
        aceptarButton.setTitle("Pausar", for: .normal)
    }
    
    @objc func refreshVal(){
        if let start = initialTime{
            let diff = Date().timeIntervalSince(start)
            setTimerLabel(Int(diff))
        }else{
            finalTimer()
            setTimerLabel(0)
        }
    }
    
    func setTimerLabel(_ val: Int){
        let time = secToHoursMinToSec(val)
        let timeToString = timeToString(hr: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeToString
    }
    
    func secToHoursMinToSec(_ ms: Int) -> (Int, Int, Int){
        let hr = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hr, min, sec)
    }
    
    func timeToString(hr: Int, min: Int, sec: Int) -> String{
        var timeToString = ""
        timeToString += String(format: "%02d", hr)
        timeToString += ":"
        timeToString += String(format: "%02d", min)
        timeToString += ":"
        timeToString += String(format: "%02d", sec)
        return timeToString
    }
    
    func finalTimer(){
        if setTimer != nil{
            setTimer.invalidate()
        }
        countingSet(false)
        aceptarButton.setTitle("Aceptar", for: .normal)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        finalTimeSet(date: nil)
        initialTimeSet(date: nil)
        timerLabel.text = timeToString(hr: 0, min: 0, sec: 0)
        finalTimer()
    }
    
    func initialTimeSet(date: Date?){
        initialTime = date
        userDefaults.set(initialTime, forKey: initialTimeKey)
    }
    
    func finalTimeSet(date: Date?){
        finalTime = date
        userDefaults.set(finalTime, forKey: finalTimeKey)
    }
    
    func countingSet(_ val: Bool){
        countingVar = val
        userDefaults.set(countingVar, forKey: countingKey)
    }
    
    
}

