//
//  AddEvenementViewController.swift
//  MyWishList
//
//  Created by Boksic Rodrigo on 22/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

class AddEvenementViewController: UIViewController, UITableViewDelegate
{
    @IBOutlet var nomEventField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Action du bouton pour ajouter a la liste le nouvel evenement
    @IBAction func addEventButtonAction(sender: AnyObject)
    {
        //Reference à l'AppDelegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference au model
        let contextEvent: NSManagedObjectContext = appDel.managedObjectContext!
        let entiteEvent = NSEntityDescription.entityForName("Event", inManagedObjectContext: contextEvent)
        
        //Créer et initaliser une instance de notre entité
        var newItemEvent = ModelEvent(entity: entiteEvent!, insertIntoManagedObjectContext: contextEvent)
        
        //Recupère les valeurs entrer pour nos variable
        newItemEvent.nomEvent = nomEventField.text
        
        //Sauvegarde le context
        contextEvent.save(nil)
        println(newItemEvent)
        
        //Ferme le popup
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
}