//
//  CodeViewController.swift
//  obd1Directory
//
//  Created by Tyler on 11/1/18.
//  Last modified on 11/5/18.
//  Copyright © 2018 Harold. All rights reserved.
//

import UIKit
import Firebase

class CodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var allCodes = [String]()
    var values = [String]()
    var make = String()
    var model = String()
    var dbRef: DatabaseReference!
    @IBOutlet weak var vehicleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        dbRef = Database.database().reference()
        vehicleLabel.numberOfLines = 4
        vehicleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        vehicleLabel.textColor = .white
        vehicleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        vehicleLabel.text = "Engine codes for your " + make + " " + model + ": "
        dbRef.child("MODEL").child(make).child(model).observe(.value, with: {(snapshot) in
            var codeMap = [String]()
            guard let value = snapshot.value as? NSArray else{
                print("No records returned")
                return
            }
            for model in value{
                //adds each code to the array
                if var value = model as? String{
                codeMap.append(value)
                }
            }
            self.readCodes(data: codeMap)
            
        })
    }
    
    func readCodes(data:[String]){

        allCodes = data
        for d in data{
            values.append(d)
        }
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        //need to fix Y value so it is not a static number, has to vary with the phone size
        var myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 110, width: displayWidth, height: displayHeight - barHeight - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.backgroundColor = UIColor.clear
        myTableView.dataSource = self
        myTableView.delegate = self
        let scrollPoint = CGPoint(x:0, y:myTableView.contentSize.height - myTableView.frame.size.height)
        myTableView.setContentOffset(scrollPoint, animated: true)
        self.view.addSubview(myTableView)
    }
    
    @IBAction func backtoBrand(_ sender: Any) {
        performSegue(withIdentifier: "backToBrand", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //because both the key (code number) and value (code) are in the same text/label, I used a
        //mutible string to it is indented properly

        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = 50
        let mutString = NSAttributedString(string: values[indexPath.row], attributes: [NSAttributedStringKey.paragraphStyle: paragraph])
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.textColor = .white
        //cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.numberOfLines = 15
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel!.attributedText = mutString
    
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
