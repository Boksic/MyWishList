//
//  ListTableViewController.swift
//  myList
//
//  Created by Boksic Rodrigo on 03/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController
{
    //Declaration de ma liste de voeux
    var myList: Array<AnyObject> = []
    
    //Fonction appelé lorsque la vue en question ce charge
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
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        let freq = NSFetchRequest(entityName: "Voeu")
        
        myList = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
    }
    
    //Fonction qui prepare tous les données dont nous avons besoin pour la transition entre la page du tableau de voeux a la page de details
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "Details"
        {
            var selectedItem: NSManagedObject = (myList[self.tableView.indexPathForSelectedRow()!.row] as! NSManagedObject) as NSManagedObject
            
            let DVC: DetailsTableViewController = segue.destinationViewController as! DetailsTableViewController
            
            //Affectation des valeurs de chaque variable
            DVC.nom = selectedItem.valueForKey("nom") as! String
            DVC.site = selectedItem.valueForKey("site") as! String
            DVC.prix = selectedItem.valueForKey("prix") as! String
            DVC.descriptions = selectedItem.valueForKey("descriptions") as! String
            
            let imageData:NSData = selectedItem.valueForKey("photo") as! NSData
            let contactImage:UIImage = UIImage(data: imageData)!
            
            DVC.image = contactImage
                
            DVC.existingItem = selectedItem
        }
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
        return myList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellID: NSString = "VoeuCell"
        
        var cell: CustomCellTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID as String) as! CustomCellTableViewCell
        
        if let ip = indexPath as NSIndexPath!
        {
            //Declaration des informations de la liste
            var data: NSManagedObject = myList[ip.row] as! NSManagedObject
            
            let nomLabel = data.valueForKey("nom") as! String
            let imageData:NSData = data.valueForKey("photo") as! NSData
            
            let contactImage:UIImage = UIImage(data: imageData)!
            
            //Affectation des informations de la liste que l'on a besoin dans la cell
            cell.nomLabel.text = nomLabel
            cell.wishImage.image = contactImage
        }
        
        //Degradé de couleur vert sur les cells
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: 55/255.0, green: 188/255.0, blue: 155/255.0, alpha: 0.1)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 55/255.0, green: 188/255.0, blue: 155/255.0, alpha: 0.2)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        //Reference à l'AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference au model
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if let tv = tableView as UITableView?
            {
                context.deleteObject(myList[indexPath.row] as! NSManagedObject)
                myList.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                println(myList)
            }
            
            var erreur: NSError? = nil
            
            if !context.save(&erreur)
            {
                abort()
            }
        }
    }
    
    //Bouton qui permet de partager des voeux
    @IBAction func shareButtonAction(sender: AnyObject)
    {
        let vc = UIActivityViewController(activityItems: [], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //Bouton pour retourner a la liste de voeux
    @IBAction func retourButtonAction(sender: AnyObject)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
