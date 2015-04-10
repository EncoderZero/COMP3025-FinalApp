//
//  SecondViewController.swift
//  AlarmClock
//
//  Created by 200213257 on 2015-03-26.
//  Copyright (c) 2015 200213257. All rights reserved.
//

import UIKit
import MediaPlayer

class SecondViewController: UIViewController, MPMediaPickerControllerDelegate {
    var mediaItem:MPMediaItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if ( cell == mediaCell ) {
            
            let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
            mediaPicker.delegate = self
            mediaPicker.prompt = "Select any song!"
            mediaPicker.allowsPickingMultipleItems = false
            presentViewController(mediaPicker, animated: true, completion: {})
            
        }
        
    }

    @IBAction func pickAlarm(sender: UIButton) {
        let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        mediaPicker.delegate = self
        mediaPicker.prompt = "Select any song!"
        mediaPicker.allowsPickingMultipleItems = false
        presentViewController(mediaPicker, animated: true, completion: {})
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItems:MPMediaItemCollection) -> Void
    {
        var aMediaItem = mediaItems.items[0] as MPMediaItem
        if (( aMediaItem.artwork ) != nil) {
            mediaImageView.image = aMediaItem.artwork.imageWithSize(mediaCell.contentView.bounds.size);
            mediaImageView.hidden = false;
        }
        
        self.mediaItem = aMediaItem;
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
}

