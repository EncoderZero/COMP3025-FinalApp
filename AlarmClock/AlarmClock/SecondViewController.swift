//
//  SecondViewController.swift
//  AlarmClock
//
//  Created by 200213257 on 2015-03-26.
//  Copyright (c) 2015 200213257. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

class SecondViewController: UIViewController, MPMediaPickerControllerDelegate {
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext

    @IBOutlet weak var militaryTimeSwitch: UISwitch!
    var alarmExists = false;
    var time: NSDate = NSDate();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        // fetch entity model
        let entityDescription =
        NSEntityDescription.entityForName("Entity",
            inManagedObjectContext: managedObjectContext!)
        
        // build model fetch request
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        
        // if data is retrived, attempt to set fetched data
        if let results = objects {
            if results.count > 0 {
                // get latest row
                var match = results[results.count - 1] as NSManagedObject
                
                if(match.valueForKey("militaryTime") != nil){
                    var militaryTime = match.valueForKey("militaryTime") as Bool;
                    militaryTimeSwitch.on = militaryTime;
                }
                if(match.valueForKey("alarmTime") != nil){
                    self.alarmExists = true;
                    self.time = match.valueForKey("alarmTime") as NSDate;
                }
                
                // if multiple rows exist, clear other rows
                if results.count > 1 {
                    for(var i = 0; i < results.count - 1; i++){
                        match = results[i] as NSManagedObject
                        managedObjectContext?.deleteObject(match);
                    }
                    
                } else {
                    println("break");
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /** 
     * displays list of local songs to user for alarm selection
     **/
    @IBAction func pickAlarm(sender: UIButton) {
        let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        mediaPicker.delegate = TableViewController()
        mediaPicker.prompt = "Select any song!"
        mediaPicker.allowsPickingMultipleItems = false
        presentViewController(mediaPicker, animated: true, completion: {})
    }
    
    /**
     * On switch set to military time, or 12 hour clock format
     **/
    @IBAction func timeFormat(sender: UISwitch) {
        var error: NSError?
        
        // save to data store
        let entityDescription =
        NSEntityDescription.entityForName("Entity",
            inManagedObjectContext: managedObjectContext!);
        
        let entity = Entity(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext);
        
        // save settings
        entity.militaryTime = sender.on;
        if(self.alarmExists){
            entity.alarmTime = self.time;
        }
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason);
        } else {
            println(time);
        }
    }
}

