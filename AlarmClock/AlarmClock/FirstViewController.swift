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
    var militaryTime: Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    /**
     * Called when view is rendered
     **/
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
        // get current time
        var date = NSDate();
        var format = NSDateFormatter();
        var formatString: String;
        
        // set time format
        if(self.militaryTime){
            formatString = "HH:MM:ss";
        }else{
            formatString = "h:mm:ssa";
        }
        format.dateFormat = formatString;
        
        var time = format.stringFromDate(date)
        CurrentTime.text = time;
        
    }
    
    /**
     * Loads saved alarm settings if they exist
     **/
    private func loadAlarm(){
        // get entity model
        let entityDescription =
        NSEntityDescription.entityForName("Entity",
            inManagedObjectContext: managedObjectContext!)
        
        // get results from coredata
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        
        // if results are valid data
        if let results = objects {
            // get last entry
            var match:NSManagedObject;
            if results.count > 0 {
                match = results[results.count - 1] as NSManagedObject
                if(match.valueForKey("alarmTime") != nil){
                    // prep date in specified format
                    var format = NSDateFormatter();
                    format.dateFormat = "hh:mma";
                    var time = match.valueForKey("alarmTime") as NSDate;
                    var timeString = format.stringFromDate(time);
                    
                    
                    
                    
                    SetAlarm.text = timeString;
                    if results.count > 1 {
                        for(var i = 0; i < results.count - 1; i++){
                            match = results[i] as NSManagedObject
                            managedObjectContext?.deleteObject(match);
                        }
                        
                    } else {
                        println("break");
                    }
                }
                // get stored military time and if it exists, set it to militaryTime variable
                if(match.valueForKey("militaryTime") != nil){
                    self.militaryTime = match.valueForKey("militaryTime") as Bool;
                }
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
        
        // save the alarm and military setting
        alarm.alarmTime = time;
        alarm.militaryTime = self.militaryTime;
        
        managedObjectContext?.save(&error)

        if let err = error {
            println(err.localizedFailureReason);
        } else {
            println(time);
        }
    }

}

