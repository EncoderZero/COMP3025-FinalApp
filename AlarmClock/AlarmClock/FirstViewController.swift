//
//  FirstViewController.swift
//  AlarmClock
//
//  Created by 200213257 on 2015-03-26.
//  Copyright (c) 2015 200213257. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext

    @IBOutlet weak var CurrentTime: UILabel!
    @IBOutlet weak var SetAlarm: UILabel!
    @IBOutlet weak var DateTimeSelection: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadAlarm();
        updateTime()
        var timer = NSTimer()
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    /**
     * Updates the time each second
     **/
    func updateTime() {
        var date = NSDate()
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        var hour = components.hour
        var minutes = components.minute
        var seconds = components.second
        CurrentTime.text = "\(hour):\(minutes):\(seconds)"
        
    }
    
    /**
     * Loads saved alarm settings if they exist
     **/
    private func loadAlarm(){
        let entityDescription =
        NSEntityDescription.entityForName("Entity",
            inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        var objects = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        
        if let results = objects {
            var match = results[results.count - 1] as NSManagedObject
            
            var format = NSDateFormatter();
            format.dateFormat = "hh:mma";
            var time = match.valueForKey("alarmTime") as NSDate;
            var timeString = format.stringFromDate(time);
            
            println(time);
            println(timeString);
            SetAlarm.text = timeString;
            if results.count > 0 {
                for(var i = 0; i < results.count - 1; i++){
                    match = results[i] as NSManagedObject
                    managedObjectContext?.deleteObject(match);
                }
                
            } else {
                println("break");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Adds an alarm to core data storage
     **/
    @IBAction func AddAlarm(sender: UIButton) {
        var time = DateTimeSelection.date;
        var format = NSDateFormatter();
        var error: NSError?
        
        format.dateFormat = "hh:mma";
        

        SetAlarm.text = format.stringFromDate(time);
        
        // save to data store
        let entityDescription =
        NSEntityDescription.entityForName("Entity",
            inManagedObjectContext: managedObjectContext!);
                
        let alarm = Entity(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext);
        
        alarm.alarmTime = time;
        
        managedObjectContext?.save(&error)

        if let err = error {
            println(err.localizedFailureReason);
        } else {
            println(time);
        }
    }

}

