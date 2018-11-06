//
//  InstructionViewController.swift
//  obd1Directory
//
//  Created by Tyler on 11/3/18.
//  Last modified on 11/5/18.
//  Copyright © 2018 Harold. All rights reserved.
//

import UIKit
import Foundation
import Firebase

//delegate that will read from the asynchronous database call, get and set the data to a global array variable so it can be used within the class
protocol MyDelegate2{
    func buildPhotos(data:[String])
}

class InstructionViewController: UIViewController {
    var make = String()
    var model = String()
    var dbRef:DatabaseReference!
    //image variables which will be implemented (current formatting issue)
    // @IBOutlet weak var instructionImage: UIImageView!
    //var makeImages = [UIImage]()
    var count = 0
    var instructions = [String]()
    
    @IBOutlet weak var bannerAd: GADBannerView!
    
    @IBOutlet weak var instructionLabel: UILabel!
  
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var hidePrev: UIButton!
    @IBOutlet weak var hideNext: UIButton!
    @IBOutlet weak var toCode: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        bannerAd.adUnitID = "ca-app-pub-4945302572759470/7715066310"
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
        toCode.isHidden = true
        
        
        
        dbRef = Database.database().reference()
        dbRef.child("PHOTOS").child(make).observe(.value, with: {(snapshot) in
            //database data variable
            guard let value = snapshot.value as? NSArray else{
                print("No records returned")
                return
            }
            var instruction = [String]()
            for instr in value{
                if let num = instr as? String{
                    instruction.append(num)
                }
                /** photo loading
                if let url = photo as? String{
                    do{
                    if let photoURL = URL(string: url){
                        let data = try Data(contentsOf: photoURL)
                        
                        var pic = UIImage(data:data)
                        urlArray.append(pic!)
                        
                        }
                    }catch let err{
                        print("Error: ")
                    }

                }
                 **/
            }
            self.buildPhotos(data: instruction)
        })
    }
    func buildPhotos(data:[String]){
        instructions = data
        //instructionImage.clipsToBounds = true
        //instructionImage.image = makeImages[count]
        //Firebase realtime cannot read periods, hence "." added below
        instructionLabel.text = instructions[count] + "."
        //percentage of progress bar = 1/array count. Therefore, any array size that is called will utilize the entire bar by the last step
        progress.progress = 1/(Float(instructions.count))
        //instructionImage.isHidden = true
        hidePrev.isHidden = true
        toCode.isHidden = true
    }
    @IBAction func toCodeList(_ sender: Any) {
        performSegue(withIdentifier: "toCode", sender: self)
    }
    @IBAction func nextButton(_ sender: Any) {
        var n:Float = 1/(Float(instructions.count))
        progress.progress += n
        hidePrev.isHidden = false
        if count < instructions.count-1{
            count = count+1
            //instructionImage.image = makeImages[count]
            instructionLabel.text = instructions[count] + "."
        }
        if count == instructions.count - 1{
            hideNext.isHidden  = true
            toCode.isHidden = false
        }
        
    }
    @IBAction func prevButton(_ sender: Any) {
        var n:Float = 1/(Float(instructions.count))
        progress.progress -= n
        hideNext.isHidden = false
        toCode.isHidden = true
        if count > 0{
            count = count - 1
            //instructionImage.image = makeImages[count]
            instructionLabel.text = instructions[count] + "."
        }
        if count == 0{
            hidePrev.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let code = segue.destination as! CodeViewController
            code.make = make
            code.model = model
        
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
