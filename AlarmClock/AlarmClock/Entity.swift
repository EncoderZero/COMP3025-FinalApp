//
//  Entity.swift
//  AlarmClock
//
//  Created by 200176338 on 2015-04-09.
//  Copyright (c) 2015 200213257. All rights reserved.
//

import Foundation
import CoreData

class Entity: NSManagedObject {

    @NSManaged var alarmTime: NSDate
    @NSManaged var militaryTime: Bool
}
