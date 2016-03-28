//
//  EvenementsTableViewController.swift
//  MyWishList
//
//  Created by Boksic Rodrigo on 19/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

class EvenementsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate
{
    //Declaration de ma liste de voeux
    var myListEvent: Array<AnyObject> = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //Fonction appelé lorsque la vue en question apparait
    override func viewDidAppear(animated: Bool)
    {
        //Reference à l'AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference au model
        let Eventcontext: NSManagedObjectContext = appDelegate.managedObjectContext!
        let Eventfreq = NSFetchRequest(entityName: "Event")
        
        myListEvent = Eventcontext.executeFetchRequest(Eventfreq, error: nil)!
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Fonction qui renvoi le nombre de colonne du tableau
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    //Fonction qui renvoi le nombre de ligne du tableau
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myListEvent.count
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    //Action du bouton pour l'ajout d'evenement...
    @IBAction func addEventButtonAction(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("showView", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        //Reference à l'AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference au model
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        println(myListEvent[indexPath.row].textLabel)
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {

            if let tv = tableView as UITableView?
            {
                context.deleteObject(myListEvent[indexPath.row] as! NSManagedObject)
                myListEvent.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                println(myListEvent)
            }
            
            var erreur: NSError? = nil
            
            if !context.save(&erreur)
            {
                abort()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showView"
        {
            var ViewController = segue.destinationViewController as! UIViewController
            
            var controller = ViewController.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
            
            ViewController.preferredContentSize = CGSize(width: 320, height: 44)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle
    {
        return .None
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellID: NSString = "EventCell"
        
        var cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID as String) as! EventTableViewCell
        
        if let ip = indexPath as NSIndexPath!
        {
            //Declaration des informations de la liste
            var dataEvent: NSManagedObject = myListEvent[ip.row] as! NSManagedObject
            
            let nomLabel = dataEvent.valueForKey("nomEvent") as! String
            
            //Affectation des informations de la liste que l'on a besoin dans la cell
            cell.textLabel?.text = nomLabel
        }
        
        return cell
    }
}
