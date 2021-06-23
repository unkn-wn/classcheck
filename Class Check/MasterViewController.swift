//
//  MasterViewController.swift
//  Class Check
//
//  Created by Leon Yee on 10/27/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit
import GoogleMobileAds

/*
var objects:[String] = []
var classDuration:[Int] = []
var classesTaken:[Int] = []
var interval:[String] = []

*/
var objects = UserDefaults.standard.array(forKey: "classNames") ?? []
var classDuration = UserDefaults.standard.array(forKey:"classDurations") ?? []
var classesTaken = UserDefaults.standard.array(forKey:"classesTaken") ?? []
var interval = UserDefaults.standard.array(forKey:"interval") ?? []

class MasterViewController: UITableViewController, GADBannerViewDelegate {

    var detailViewController: DetailViewController? = nil
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(objects)
        print(classDuration)
        print(classesTaken)
        print(interval)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appbackground")!)
        
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewRow(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        UserDefaults.standard.synchronize()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
    }
    
    func resetUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "classNames")
        UserDefaults.standard.set(objects, forKey: "classNames")
        
        UserDefaults.standard.removeObject(forKey: "classDurations")
        UserDefaults.standard.set(classDuration, forKey: "classDurations")
        
        UserDefaults.standard.removeObject(forKey: "classesTaken")
        UserDefaults.standard.set(classesTaken, forKey: "classesTaken")
        
        UserDefaults.standard.removeObject(forKey: "interval")
        UserDefaults.standard.set(interval, forKey: "interval")
    }

    override func viewWillAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func createNewRow (_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "createRowController") as! CreateRowController
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

    
    func insertNewObject(name: String, duration: Int, inter: String) {
        objects.append(name)
        classDuration.append(duration)
        classesTaken.append(0)
        interval.append(inter)
        
        resetUserDefaults()
        
        tableView.insertRows(at: [IndexPath(row: objects.count-1, section: 0)], with: .automatic)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! String
                let classDur = classDuration[indexPath.row] as!Int
                let classTake = classesTaken[indexPath.row] as! Int
                let inter = interval[indexPath.row] as! String
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.name = String(object)
                controller.numClasses = Int(classDur)
                controller.numClassesTaken = Int(classTake)
                controller.interval = String(inter)
                
                id = Int(indexPath.row)
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = ""
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! String
        cell.textLabel!.text = object
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            classDuration.remove(at: indexPath.row)
            classesTaken.remove(at: indexPath.row)
            interval.remove(at: indexPath.row)
            
            var temp = UserDefaults.standard.array(forKey: String(indexPath.row)) ?? []
            temp.removeAll()
            UserDefaults.standard.removeObject(forKey: String(indexPath.row))
            UserDefaults.standard.set(temp, forKey: String(indexPath.row))
            
            resetUserDefaults()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "93ddb1ef67fc1f466a884b2bc9d2a528" ]

        bannerView.adUnitID = "ca-app-pub-3940256099942544/29347355716" //test id: ca-app-pub-3940256099942544/29347355716
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ]
        )
        bannerView.load(GADRequest())
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //addBannerViewToView(bannerView)
    }
    
    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }


}

