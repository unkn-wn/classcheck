//
//  CreateRowController.swift
//  Class Check
//
//  Created by Leon Yee on 12/29/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit


class CreateRowController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameOfEvent: UITextField!
    @IBOutlet weak var numberOfClasses: UITextField!
    @IBOutlet weak var intervalOfClass: UIPickerView!
    
    var name = ""
    var numClasses = 0
    var pickerValues = ["Daily", "Weekly", "Biweekly"]
    var interval = "Daily"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameOfEvent.delegate = self
        self.numberOfClasses.delegate = self
        self.intervalOfClass.delegate = self
        self.intervalOfClass.dataSource = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appbackground")!)
    }
    
    @IBAction func create(_ sender: Any) {
        
        self.name = nameOfEvent.text ?? "unnamed"
        self.numClasses = Int(numberOfClasses.text!) ?? 1
        let masterController = MasterViewController()
        masterController.insertNewObject(name: self.name, duration: self.numClasses, inter: self.interval)
        //performSegue(withIdentifier: "createdRowToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let masterController = segue.destination as? MasterViewController {
            masterController.insertNewObject(name: self.name, duration: self.numClasses, inter: self.interval)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //PICKER FUNCS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        interval = pickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerValues[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
