//
//  ModelEvent.swift
//  MyWishList
//
//  Created by Boksic Rodrigo on 23/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

@objc(ModelEvent)

class ModelEvent: NSManagedObject
{
    //Declaration des attribut de l'entité
    @NSManaged var nomEvent: String
}
