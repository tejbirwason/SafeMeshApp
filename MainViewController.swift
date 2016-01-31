//
//  MainViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Tejbir Wason on 1/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var coordinatesLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var lastRequestLabel: UILabel!
    
    var latitude = 0.0
    var longitude = 0.0
    
    @IBAction func help(sender: AnyObject) {
        
        tagAsSafe(false)
        
    }
    
    func tagAsSafe(safe: Bool){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var event = PFObject(className: "Events")
        
        var currentUser = PFUser.currentUser()
        
        event["name"] = currentUser!.username!
        event["userId"] = currentUser!.objectId!
        event["phone"] = currentUser!.valueForKey("phone")!
        event["latitude"] = latitude
        event["longitude"] = longitude
        event["safe"] = safe
        
        event.saveInBackgroundWithBlock({ (success, error) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if success == true {
                self.lastRequestLabel.text = "Last sent: "+NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
            } else {
                self.lastRequestLabel.text = "Last request failed to send"
            }
        })
    }

    @IBAction func safe(sender: AnyObject) {
        
        tagAsSafe(true)
        
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userLocation: CLLocation = locations[0]
        
        latitude = userLocation.coordinate.latitude
        
        longitude = userLocation.coordinate.longitude
        
        coordinatesLabel.text = String(format: "Location: <%.5f, %.5f>", latitude,longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
