//
//  flickrSearchViewController.swift
//  Filterer
//
//  Created by Yi Zhou on 3/31/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

class flickrSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchText: UITextField!
    var tagString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func flickrSearch(sender: AnyObject) {
        self.tagString  = searchText.text
        searchText.resignFirstResponder()
        performSegueWithIdentifier("showCollectionView", sender: sender)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionView" {
            let vc = segue.destinationViewController as! flickrCollectionViewController
            vc.tag = self.tagString!
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        flickrSearch(textField)
        return true
    }

}
