//
//  ModelSelectViewController.swift
//  obd1Directory
//
//  Created by Tyler on 10/30/18.
//  Last modified on 11/5/18.
//  Copyright © 2018 Harold. All rights reserved.
//

import UIKit
import Firebase

//delegate that will read from the asynchronous database call, get and set the data to a global array variable so it can be used within the class
protocol MyDelegate{
    func buildNames(data:[String])
}

class ModelSelectViewController: UIViewController {
    
    var selectModelString = String()
    var dbRef: DatabaseReference!
    var selectedModel = String()
    @IBOutlet weak var selectModel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        dbRef = Database.database().reference()
        dbRef.child("MODEL").observe(.value, with: {(snapshot)in
            var modelArray = [String]()
            guard let value = snapshot.value as? NSDictionary else{
                print("No records returned")
                return}
            //outer loop gets the correct subfolder using the brand data
            for model in value{
                var m = model.key as! String
                //if the current subfolder is the folder we want, we need to get the model subfolders from it. Unfortunately this currently involves a double loop, will need to look into finding another way to acheive this. Map?
                if (m == self.selectModelString){
                    var dict = model.value as! NSDictionary
                    for d in dict{
                        //the first value from the brand key is null, with this if statement the program will jump over it
                        if var car = d.key as? String{
                            let thisModel = car
                            modelArray.append(car)
                        }
                    }
                }
            }
            self.buildNames(data: modelArray)
            
        })
        selectModel.center.x = self.view.center.x
        selectModel.textColor = .white
        
        selectModel.text = "Select your " + selectModelString + ": "
        selectModel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    func buildNames(data:[String]){
        let stackView = createStackView(with: UILayoutConstraintAxis.vertical)
        for model in data{
            var button = UIButton(frame: CGRect(x:100, y:100, width:200, height:50))
            button.setTitle(model, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            button.accessibilityHint = model
            button.addTarget(self, action: #selector(modelPressed), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //self.view = view
        
    }
    func createStackView(with layout: UILayoutConstraintAxis) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = layout
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }
    @objc func modelPressed(sender:UIButton){
        selectedModel = sender.accessibilityHint!
        performSegue(withIdentifier: "toDirectory", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToMake", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDirectory"{
            let directory = segue.destination as! ViewController
            directory.modelSelected = selectedModel
            directory.makeSelected = selectModelString
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CheckInternet.Connection() == false{
            self.Alert(message: "Your device is not connected to the internet. Please connect in order to continue.")
        }
    }
    
    func Alert (message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated:true, completion: nil)
        
    }

}
