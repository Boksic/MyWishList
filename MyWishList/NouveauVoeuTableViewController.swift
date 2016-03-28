//
//  NouveauVoeuTableViewController.swift
//  myList
//
//  Created by Boksic Rodrigo on 09/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit
import CoreData

class NouveauVoeuTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet var nomTextField: UITextField!
    @IBOutlet var siteTextField: UITextField!
    @IBOutlet var prixTextField: UITextField!
    @IBOutlet var descriptionsTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    //Lorsque la page ce charge...
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //Affectation de l'image choisi par l'utilisateur a l'UIImageView present sur la page (Apercu de l'image choisi)
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        //Quitte le photolibrary lorsque l'on clique sur l'image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.imageView.image = image
    }
    
    //Action pour sauvegarder le nouveau voeux
    @IBAction func saveButtonAction(sender: AnyObject)
    {
        //Reference à l'AppDelegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference au model
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let entite = NSEntityDescription.entityForName("Voeu", inManagedObjectContext: context)
        
        //Créer et initaliser une instance de notre entité
        var newItem = ModelVoeu(entity: entite!, insertIntoManagedObjectContext: context)
        
        //Recupère les valeurs entrer pour nos variable
        newItem.nom = nomTextField.text!
        newItem.site = siteTextField.text!
        newItem.prix = prixTextField.text!
        newItem.descriptions = descriptionsTextField.text!
        
        let image:NSData = UIImagePNGRepresentation(imageView.image!)!
        
        newItem.photo = image
        
        
        //Sauvegarde le context
        context.save(nil)
        print(newItem)
        
        //Retourne a la vue d'avant
        let switchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VoeuListView") as! ListTableViewController
        
        self.navigationController?.popToViewController(switchViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //Action pour ajouter une image
    @IBAction func imageButtonAction()
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.editing = false
        imagePicker.delegate = self
        
        //Reglage du message du popup et des differents bouttons du popup
        let actionSheet = UIAlertController(title: "Choisir une image", message: "Phototheque ou prendre une Photo", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Creation du bouton pour acceder a la phototheque de l'appareil
        let photothequeButton = UIAlertAction(title: "Photothéque", style: UIAlertActionStyle.Default)
        {
            (photothequeSelect) -> Void in
            
            //Ouverture de la bibliotheque de photo
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        //Creation du bouton pour acceder a l'appareil photo de l'appareil
        let prendrePhotoButton = UIAlertAction(title: "Prendre photo", style: UIAlertActionStyle.Default)
        {
            (prendrePhotoSelect) -> Void in
            
            //Gestion d'erreur car le simulateur ne possede pas de camera
            //Si la camera est accesible...
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                //Ouverture de la camera de l'appareil
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            //sinon...
            else
            {
                print("Camera inaccessible")
            }
        }
        
        //creation du bouton annuler
        let annulerButon = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel)
        {
            (annulerSelect) -> Void in
        }
        
        //Ajout des bouttons dans le popup
        actionSheet.addAction(photothequeButton)
        actionSheet.addAction(prendrePhotoButton)
        actionSheet.addAction(annulerButon)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}
