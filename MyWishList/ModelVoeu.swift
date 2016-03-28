//
//  Model.swift
//  myList
//
//  Created by Boksic Rodrigo on 03/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

@objc(ModelVoeu)

class ModelVoeu: NSManagedObject
{
    //Declaration des attribut de l'entité
    @NSManaged var nom: String
    @NSManaged var site: String
    @NSManaged var prix: String
    @NSManaged var descriptions: String
    @NSManaged var photo: NSData
}
