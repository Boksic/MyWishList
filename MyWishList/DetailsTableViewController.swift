//
//  DetailsTableViewController.swift
//  MyWishList
//
//  Created by Boksic Rodrigo on 18/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewController: UITableViewController, PayPalPaymentDelegate
{
    @IBOutlet var NomLabel: UILabel!
    @IBOutlet var SiteButtonText: UIButton!
    @IBOutlet var DescriptionTextView: UITextView!
    @IBOutlet var PrixLabel: UILabel!
    @IBOutlet var DetailImageView: UIImageView!
    
    var config = PayPalConfiguration()
    
    //Declaration de ma liste de voeux
    var myList: Array<AnyObject> = []
    
    //Declaration des variables de la page Detail
    var nom = String()
    var site = String()
    var descriptions = String()
    var prix = String()
    var image = UIImage()
    
    var existingItem: NSManagedObject!
    
    //Lorsque la vue ce charge...
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Lorsque un item est selectionné
        if (existingItem != nil)
        {
            //On affecte les valeurs du voeu
            NomLabel.text = nom
            SiteButtonText.setTitle(site, forState: .Normal)
            PrixLabel.text = prix+"€"
            DescriptionTextView.text = descriptions
            DetailImageView.image = image
        }
        
        //Ajuster dynamiquement la hauteur d'une ligne du tableau
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Fonction permettant en un click d'acceder au site web souhaité
    @IBAction func goToSiteButtonAction(sender: AnyObject)
    {
        //Declaration des differents url
        var url : NSURL
        var urlCorige1 : NSURL
        var urlCorige2 : NSURL
        
        //Declaration de l'url de type NSURL avec le string du site
        url = NSURL(string: site)!
        
        //Un site internet ne s'ouvre que si l'url est complet(Avec "http://www.")
        //Si l'url est complet...
        if (site.rangeOfString("http://www.") != nil)
        {
            //On lance l'url dans Safari
            UIApplication.sharedApplication().openURL(url)
        }
        //Si il ne contient pas "www."...
        else if (site.rangeOfString("www.") == nil)
        {
            //On rajoute a l'url "http://www." puis on lance l'url dans Safari
            urlCorige1 = NSURL(string: "http://www.\(url)")!
            UIApplication.sharedApplication().openURL(urlCorige1)
        }
        //Si il ne contient pas "http://"...
        else if (site.rangeOfString("http://") == nil)
        {
            //On rajoute a l'url "http://" puis on lance l'url dans Safari
            urlCorige2 = NSURL(string: "http://\(url)")!
            UIApplication.sharedApplication().openURL(urlCorige2)
        }
    }
    
    //Fonction permettant de faire un "don" par PayPal
    @IBAction func cotiserButtonAction(sender: AnyObject)
    {
        //Mettre ici le montant que nous voulons donner...
        let amount = NSDecimalNumber(string: prix)
        
        println("amount \(amount)")
        
        var payment = PayPalPayment()
        payment.amount = amount
        payment.currencyCode = "EUR"
        payment.shortDescription = "Montant"
        
        if (!payment.processable)
        {
            println("You messed up!")
        }
        else
        {
            println("This works")
            var paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
            self.presentViewController(paymentViewController, animated: false, completion: nil)
        }
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        println("Le payment PayPal à été realiser avec succes !")
        
        paymentViewController?.dismissViewControllerAnimated(true, completion:
            { () -> Void in
                //Mettre ici le code pour envoyer la preuve de transaction au serveur...
                println("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
    }
    
    //Fonction permettant de gérer l'annulation de payment par PayPal
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!)
    {
        println("Payment par PayPal annulé !")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
