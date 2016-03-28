//
//  CustomCellTableViewCell.swift
//  myList
//
//  Created by Boksic Rodrigo on 08/06/2015.
//  Copyright (c) 2015 Boksic Rodrigo. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell
{
    //Declaration des infos a afficher dans la cellule de la liste
    @IBOutlet var nomLabel: UILabel!
    @IBOutlet var wishImage: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
