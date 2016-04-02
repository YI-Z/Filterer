//
//  preloadViewController.swift
//  Filterer
//


import UIKit

class preloadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var flickrButton: UIButton!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set buttons alpha to zero
        self.cameraButton.alpha = 0
        self.albumButton.alpha = 0
        self.flickrButton.alpha = 0
        
        self.fadeOut()  // delays the loading image and fade out in 2 seconds
        
    }
    
    
    // fade out in 2 sec after loading
    func fadeOut() {
        UIView.animateWithDuration(2, animations: {
            self.loadingImageView.alpha = 0.3
            self.loadingTextLabel.alpha = 0.3
            self.cameraButton.alpha = 1
            self.albumButton.alpha = 1
            self.flickrButton.alpha = 1
        })
        
    }
    
    // touch buttons
    @IBAction func onCamera(sender: AnyObject) {
        showCamera()
    }
    
    @IBAction func onAlbum(sender: AnyObject) {
        showAlbum()
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = image
        }
        dismissViewControllerAnimated(true, completion: {self.performSegueWithIdentifier("imageDisplay", sender: nil)})
    }
    
    
    
    // prepare segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageDisplay" {
            let destinateVC = segue.destinationViewController as! ViewController
            destinateVC.originalImage = self.selectedImage
        }
    }
}
