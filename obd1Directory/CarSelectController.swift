//
//  CarSelectController.swift
//  obd1Directory
//
//  Created by Tyler on 10/29/18.
//  Last modified on 11/5/18.
//  Copyright © 2018 Harold. All rights reserved.
//

import UIKit

class CarSelectController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //basic vehicle make array setup. Images will be moved over to the database by next update.
    var makeImages: [UIImage] = [
        UIImage(named: "toyota")!,
        UIImage(named: "lexus")!,
        UIImage(named: "honda")!,
        UIImage(named: "mazda")!
    ]
    var selectedBrand = String()
    @IBOutlet weak var makeCollection: UICollectionView!
    var brandPickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        brandPickerData = ["TOYOTA", "LEXUS", "HONDA", "MAZDA"]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makeImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = makeCollection.dequeueReusableCell(withReuseIdentifier: "button", for: indexPath) as? MakeCollectionViewCell
        cell?.make.setTitle("", for: .normal)
        cell?.make.setImage(makeImages[indexPath.item], for: .normal)
        //sends hint with brand name that can be transferred to the following viewcontrollers
        cell?.make.accessibilityHint = brandPickerData[indexPath.row]
        cell?.make.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return cell!
    }
    
    @objc func buttonPressed(sender:UIButton){
        selectedBrand = sender.accessibilityHint!
        performSegue(withIdentifier: "toModel", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let model = segue.destination as! ModelSelectViewController
        model.selectModelString = selectedBrand
        
    }

}
