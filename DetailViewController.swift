//
//  DetailViewController.swift
//  
//
//  Created by Leon Yee on 6/18/20.
//

import UIKit

var id:Int = 0
//var tookClassArray:[String] = []
var tookClassArray = UserDefaults.standard.array(forKey: String(id)) ?? []



class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var tookClassTable: UITableView!
    @IBOutlet weak var nextClassDate: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lastClass: UILabel!
    
    var name:String = ""
    var numClasses:Int = 0
    var numClassesTaken:Int = 0
    var interval:String = ""
    
    override func viewDidLoad() {
        tookClassArray = UserDefaults.standard.array(forKey: String(id)) ?? []

        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appbackground")!)
        tookClassTable.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tookClassTable.layer.borderColor = UIColor.white.cgColor
        tookClassTable.layer.borderWidth = 1.0
        
        
                
        let calendar = UIBarButtonItem(image: UIImage(named: "date2"), style: .plain, target: self, action: #selector(goToCalendar(_:)))
        navigationItem.rightBarButtonItem = calendar
        
        
        
        //first time stuff
        
        if #available(iOS 13.0, *){
            
        } else {
            //let temp = UserDefaults.standard.bool(forKey: "firstTime")
            //if(temp == false){
                let back = UIBarButtonItem(title: "< Classes", style: .plain, target: self, action: #selector(goBack(_:)))
                navigationItem.leftBarButtonItem = back
            //}
        }
        
        //tableview
        self.tookClassTable.register(UITableViewCell.self, forCellReuseIdentifier: "tookClassCell")
        tookClassTable.delegate = self
        tookClassTable.dataSource = self
        tookClassTable.reloadData()
        
        
        //classes taken stuff
        sportName.text = name
        if(numClasses == numClassesTaken){
            numClassesTaken = 0
            classesTaken[id] = 0
            UserDefaults.standard.removeObject(forKey: "classesTaken")
            UserDefaults.standard.set(classesTaken, forKey: "classesTaken")
            duration.text = String(numClasses)
            
        } else {
            duration.text = String(numClasses-numClassesTaken)
        }
        
        
        //next class stuff
        if(tookClassArray.count > 0){
            let format = DateFormatter()
            format.dateFormat = "MM/dd/yyyy"
            
            if(interval == "Daily"){
                guard let date = format.date(from: tookClassArray[0] as! String) else {
                    fatalError()
                }
                var dateComponent = DateComponents()
                dateComponent.day = 1
                let added = Calendar.current.date(byAdding: dateComponent, to: date)!
                
                nextClassDate.text = format.string(from: added)
            } else if(interval == "Weekly"){
                guard let date = format.date(from: tookClassArray[0] as! String) else {
                    fatalError()
                }
                var dateComponent = DateComponents()
                dateComponent.weekOfYear = 1
                let added = Calendar.current.date(byAdding: dateComponent, to: date)!
                
                nextClassDate.text = format.string(from: added)
            } else if(interval == "Biweekly"){
                guard let date = format.date(from: tookClassArray[0] as! String) else {
                    fatalError()
                }
                var dateComponent = DateComponents()
                dateComponent.weekOfYear = 2
                let added = Calendar.current.date(byAdding: dateComponent, to: date)!
                
                nextClassDate.text = format.string(from: added)
            }
            
        }
        nextClassDate.layer.borderColor = UIColor.white.cgColor
        nextClassDate.layer.borderWidth = 3.0
        nextClassDate.backgroundColor = UIColor(white: 0, alpha: 0.25)
        nextClassDate.layer.cornerRadius = 8
        nextClassDate.layer.masksToBounds = true
        
        
        //
        
        
        // Do any additional setup after loading the view.
        UserDefaults.standard.synchronize()
    }
    
    @objc func goBack(_ sender: Any){
        performSegue(withIdentifier: "detailToList", sender: self)
    }
    
    @objc func goToCalendar(_ sender: Any){
        
        let viewcont = secondDetailViewController()
        viewcont.classdates = tookClassArray
        self.navigationController?.pushViewController(viewcont, animated: true)
        
    }

    
    

    @IBAction func increaseClass(_ sender: Any) {
        numClassesTaken+=1
        let tempnum:Int = classesTaken[id] as! Int
        classesTaken[id] = tempnum+1
        UserDefaults.standard.removeObject(forKey: "classesTaken")
        UserDefaults.standard.set(classesTaken, forKey: "classesTaken")
        
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy"
        
        tookClassArray.insert(format.string(from: Date()), at: 0)
        tookClassTable.beginUpdates()
        tookClassTable.insertRows(at: [IndexPath(row: 0, section:0)], with: .top)
        tookClassTable.endUpdates()
        
        UserDefaults.standard.removeObject(forKey: String(id))
        UserDefaults.standard.set(tookClassArray, forKey: String(id))
        
        viewDidLoad()
    }
    
    
    // MARK: TABLE VIEW FUNCS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tookClassArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tookClassTable.dequeueReusableCell(withIdentifier: "tookClassCell")!
        
        lastClass.text = ""
        
        cell.textLabel?.text = tookClassArray[indexPath.row] as? String
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor(white: 1, alpha: 0.50)
        
        if(tookClassArray.count >= numClasses){
            let temp: String = ("Most recent class: " + (tookClassArray.last as! String))
            lastClass.text! = temp
            tookClassArray = []
            UserDefaults.standard.removeObject(forKey: String(id))
            UserDefaults.standard.set(tookClassArray, forKey: String(id))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tookClassArray.remove(at: indexPath.row)
            numClassesTaken -= 1
            let num:Int = classesTaken[id] as! Int
            classesTaken[id] = num - 1
            
            UserDefaults.standard.removeObject(forKey: "classesTaken")
            UserDefaults.standard.set(classesTaken, forKey: "classesTaken")
            
            UserDefaults.standard.removeObject(forKey: String(id))
            UserDefaults.standard.set(tookClassArray, forKey: String(id))
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewDidLoad()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
