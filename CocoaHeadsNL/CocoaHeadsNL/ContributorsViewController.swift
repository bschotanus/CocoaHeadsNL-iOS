//
//  ContributorsViewController.swift
//  CocoaHeadsNL
//
//  Created by Berend Schotanus on 27-08-15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import UIKit

class ContributorsViewController: PFQueryCollectionViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Contributor"
        self.paginationEnabled = false
        self.pullToRefreshEnabled = false
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContributorCell.Identifier, forIndexPath: indexPath) as! ContributorCell
        
        if let contributor = self.objectAtIndexPath(indexPath) as? Contributor, name = contributor.name {
            cell.nameLabel.text = name
            cell.fetchTask?.cancel()
            if let a = contributor.avatar_url, url = NSURL(string: a) {
                let task = fetchImageTask(url, forImageView: cell.avatarView)
                cell.fetchTask = task
                task.resume()
            }
        } else {
            cell.nameLabel.text = "Somebody"
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)

        guard let contributors = objects as? [Contributor], let urlString = contributors[indexPath.row].url else {
            return
        }

        if let url = NSURL(string: urlString) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    // MARK: Networking
    
    lazy var remoteSession: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchImageTask(url: NSURL, forImageView imageView: UIImageView) -> NSURLSessionDataTask {
        let task = remoteSession.dataTaskWithRequest(NSURLRequest(URL: url)) {
            (data, response, error) in
            if let data = data {
            let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue()) {
                    imageView.image = image
                }
            }
        }
        return task
    }
    
    //MARK: - Parse PFQueryTableViewController methods
    
    override func queryForCollection() -> PFQuery {
        let contributorQuery = Contributor.query()!
        contributorQuery.orderByDescending("commit_count")
        
        return contributorQuery
    }
    
}
