//
//  ViewController.swift
//  obd1Directory
//
//  Created by Tyler on 10/29/18.
//  Last modified on 11/5/18.
//  Copyright © 2018 Harold. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    //make and model pulled from previous class
    var makeSelected = String()
    var modelSelected = String()
    //ad object
    @IBOutlet weak var bannerView: GADBannerView!
    //connected buttons to change text specifics programmatically
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var codeButton: UIButton!
    
    //back button to return user to start
    @IBAction func startOver(_ sender: Any) {
        performSegue(withIdentifier: "backtoBrand", sender: self)
    }
   //takes user to code list using vehicle parameters
    @IBAction func toCodes(_ sender: Any) {
        performSegue(withIdentifier: "toCodes", sender: self)
    }
    
    //takes user to obd1 reading instructions using vehicle parameters
    @IBAction func toInstructions(_ sender: Any) {
        performSegue(withIdentifier: "toInstructions", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        instructionButton.titleLabel?.numberOfLines = 3
        codeButton.titleLabel?.numberOfLines = 3
        bannerView.adUnitID = "ca-app-pub-4945302572759470/7715066310"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
    this method sends the make and model to each class, therefore the database can determine what information to pull
    **/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCodes"{
            let code = segue.destination as! CodeViewController
            code.make = makeSelected
            code.model = modelSelected
        }
        if segue.identifier == "toInstructions"{
            let instr = segue.destination as! InstructionViewController
            instr.make = makeSelected
            instr.model = modelSelected
        }
        
    }


}

