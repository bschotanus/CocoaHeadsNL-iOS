//
//  ContributorCell.swift
//  CocoaHeadsNL
//
//  Created by Berend Schotanus on 27-08-15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import UIKit

class ContributorCell: UICollectionViewCell {
    static let Identifier = "contributorCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    weak var fetchTask: NSURLSessionDataTask? = nil
    
}
