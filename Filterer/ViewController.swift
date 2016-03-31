//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var filteredImage: UIImage?
    var originalImage: UIImage?
    var prefilteredImage: UIImage?  // a property to keep track of prefiltered image
    var filtered : Bool = false
    var originalBool : Bool = true
    var filterSelected : String?
    var sliderValue: Float?
    
    let buttons : [String] = ["Brightness", "Contrast", "Saturation", "Gamma",
                              "Blur", "Vintage", "Grey", "Invert"]  // the actual content of the collection view
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var secondaryView: UIImageView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var sliderMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var sliderButton: UISlider!
    @IBOutlet weak var savePhotoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        compareButton.enabled = filtered
        secondaryView.alpha = 0
        EditButton.enabled = false
        imageView.image = originalImage
        prefilteredImage = originalImage
        savePhotoLabel.alpha = 0
        // layout the collectionView
        layoutCollectionView()
        
    }
    
    
    func layoutCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: "filterButtons")
        collectionView.backgroundColor = secondaryMenu.backgroundColor
        secondaryMenu.addSubview(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: AdjustBrightnessWraper(); break
        case 1: AdjustContrastWraper(); break
        case 2: AdjustSaturationWraper(); break
        case 3: AdjustGammaWraper(); break
        case 4: blurWraper(); break
        case 5: toVintage(); break
        case 6: toGrey(); break
        case 7: invert(); break
        default: break
        }
    }
    
    // data source for collectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filterButtons", forIndexPath: indexPath) as! ButtonCollectionViewCell
        cell.imageView?.image = UIImage(named: buttons[indexPath.row])
        cell.textLabel?.text = buttons[indexPath.row]
        
        return cell
    }
    
    
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let exportImage = filteredImage ?? originalImage
        let activityController = UIActivityViewController(activityItems: ["Check out my filterer",exportImage!], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(activityType : String?, completed : Bool, returnedItems : [AnyObject]?, activityError : NSError?) -> (Void) in
            if activityType == UIActivityTypeSaveToCameraRoll {
                if completed {
                    self.savePhotoLabel.alpha = 1
                    UIView.animateWithDuration(2, animations: {self.savePhotoLabel.alpha = 0})
                }
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            prefilteredImage = originalImage
            resetParameters()  // reset paremeters
        }
    }
    
    func resetParameters() {
        filtered = false  // any new opened image will be original
        filteredImage = nil  // reset paremeters
        compareButton.enabled = filtered
        EditButton.enabled = false
        filterSelected = nil
        secondaryView.alpha = 0
        // hide any secondary menu or slider menu
        if secondaryMenu.isDescendantOfView(view) {
            hideSecondaryMenu()
        }
        if sliderMenu.isDescendantOfView(view) {
            hideSliderMenu()
        }
        filterButton.selected = false
        view.layoutIfNeeded()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if sliderMenu.isDescendantOfView(view) {
            hideSliderMenu()
        }
        
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(48)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    
    // filter buttons
    func AdjustBrightnessWraper() {
        filterSelected = "Brightness"
        hideSecondaryMenu()
        showSliderMenu()
        filterButton.selected = false
        EditButton.enabled = true
        
    }
    func AdjustBrightness(value: Double = 0.2) {
        filteredImage = adjustBrightnessFilter(prefilteredImage!, delta : value)
        crossFadeAnimate()
        EditButton.enabled = true
    }
    
    
    func AdjustContrastWraper() {
        filterSelected = "Contrast"
        hideSecondaryMenu()
        showSliderMenu()
        filterButton.selected = false
        EditButton.enabled = true
        
    }
    func AdjustContrast(value : Double = 1.2) {
        filteredImage = adjustContrastFilter(prefilteredImage!, delta : value)
        crossFadeAnimate()
        EditButton.enabled = true
    }
    
    
    func AdjustSaturationWraper() {
        filterSelected = "Saturation"
        hideSecondaryMenu()
        showSliderMenu()
        filterButton.selected = false
        EditButton.enabled = true
        
        
    }
    func AdjustSaturation(value : Double = 1.5) {
        filteredImage = adjustSaturationFilter(prefilteredImage!, delta : value)
        crossFadeAnimate()
        EditButton.enabled = true
    }
    
    
    func toGrey() {
        filteredImage = toGreyFilter(prefilteredImage!)
        crossFadeAnimate()
        EditButton.enabled = false
        afterFilter()
        prefilteredImage = filteredImage
        
    }
    
    func toVintage() {
        filteredImage = vintageFilter(prefilteredImage!)
        crossFadeAnimate()
        EditButton.enabled = false
        afterFilter()
        prefilteredImage = filteredImage
        
    }
    
    func invert() {
        filteredImage = invertFilter(prefilteredImage!)
        crossFadeAnimate()
        EditButton.enabled = false
        afterFilter()
        prefilteredImage = filteredImage
        
    }
    
    
    func AdjustGammaWraper() {
        filterSelected = "Gamma"
        hideSecondaryMenu()
        showSliderMenu()
        filterButton.selected = false
        EditButton.enabled = true
        
    }
    
    func AdjustGamma(value : Double = 0.75) {
        filteredImage = gammaFilter(prefilteredImage!, delta : value)
        crossFadeAnimate()
        EditButton.enabled = true
    }
    
    func blurWraper() {
        filterSelected = "Blur"
        hideSecondaryMenu()
        showSliderMenu()
        filterButton.selected = false
        EditButton.enabled = true
        
    }
    func blur(value : Double = 0.2) {
        filteredImage = blurFilter(prefilteredImage!, delta : value * 10)
        crossFadeAnimate()
        EditButton.enabled = true
    }
    
    // after filter settings
    func afterFilter() {
        filtered = true
        compareButton.enabled = filtered
        originalBool = false  // set display to non-original
        sourceLabel.hidden = !originalBool
        view.layoutIfNeeded()
    }
    
    // cross-fade animation
    func crossFadeAnimate() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryView.alpha = 1
            self.secondaryView.image = self.filteredImage
        })
    }
    
    
    // compare button
    @IBAction func onCompare(sender: UIButton) {
        compareOriginal()
        
    }
    
    // actual compare function
    func compareOriginal() {
        if originalBool {
            UIView.animateWithDuration(0.4, animations: {
                self.secondaryView.alpha = 1
            })
            originalBool = false
        } else {
            UIView.animateWithDuration(0.4, animations: {
                self.secondaryView.alpha = 0
            })
            originalBool = true
        }
        sourceLabel.hidden = !originalBool
        view.layoutIfNeeded()
        
    }
    
    // gestures
    @IBAction func onHold(sender: UILongPressGestureRecognizer) {
        if (filtered) {
            if sender.state == .Began {
                compareOriginal()
            }
            else if sender.state == .Ended {
                compareOriginal()
            }
        }
    }
    
    
    @IBAction func onSwipe(sender: AnyObject) {
        if (filtered) {
            compareOriginal()
        }
    }
    
    // edit button
    @IBAction func onEdit(sender: UIButton) {
        if secondaryMenu.isDescendantOfView(view) {
            hideSecondaryMenu()
        }
        
        filterButton.selected = false
        showSliderMenu()
    }
    
    
    // slider menu
    func showSliderMenu() {
        sliderButton.minimumValueImage = UIImage(named: filterSelected!)
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        // reset the slider to default
        switch filterSelected! {
        case "Blur":
            sliderButton.setValue(-1, animated: true)
            break
        default:
            sliderButton.setValue(0, animated: true)
            break
        }
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderMenu.alpha = 1.0
        }
    }
    
    func hideSliderMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }
    
    // slider button actions
    
    @IBAction func cancerSliderMenu(sender: AnyObject) {
        switch filterSelected! {
        case "Blur": sliderValue = -1
            break
        default: sliderValue = 0
            break
        }
        performFilter()
        hideSliderMenu()
        sliderValue = nil
    }
    @IBAction func sliderAction(sender: AnyObject) {
        sliderValue = sender.value
        
        // perform actions
        performFilter()
    }
    @IBAction func confirmSliderAction(sender: AnyObject) {
        hideSliderMenu()
        prefilteredImage = filteredImage
        
    }
    
    func performFilter() {
        switch filterSelected! {
        case "Brightness":
            AdjustBrightness(Double(sliderValue! / 2.0))
            afterFilter()
            break
        case "Contrast":
            AdjustContrast(Double(sliderValue! + 1.0))
            afterFilter()
            break
        case "Saturation":
            AdjustSaturation(Double(sliderValue! + 1.0))
            afterFilter()
            break
        case "Gamma":
            AdjustSaturation(Double(sliderValue! + 1.0))
            afterFilter()
            break
        case "Blur":
            blur(Double(sliderValue! + 1.0))
            afterFilter()
            break
        default:
            break
        }
    }
    
    
}

