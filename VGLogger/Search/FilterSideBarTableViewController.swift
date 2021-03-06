//
//  FilterSideBarTableViewController.swift
//  VGLogger
//
//  Created by Matthew Bennett on 11/15/17.
//  Copyright © 2017 SSU470. All rights reserved.
//

import UIKit

class FilterSideBarTableViewController: UITableViewController {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSwitch: UISwitch!
    @IBOutlet weak var ratingSlider: UISlider!
    
    let options: [String] = ["Platform", "Genre", "ESRB"]
    let platforms: [String] = ["PS4", "Xbox One", "Nintendo Switch", "Wii U", "PC", "Playstation 3", "Xbox 360", "Wii", "Nintendo 3DS", "PS Vita"]
    let genres: [String] = ["Simulator", "Sport", "Strategy", "Adventure", "Fighting", "Shooter", "Puzzle", "Racing", "RPG"]
    let esrb: [String] = ["RP", "E", "E10+", "T", "M"]
    
    let defaults = UserDefaults.standard
    //var cell: FilterSideBarTableViewCell?
    
    //Switch variables
    var ratingOn: Bool = false
    var ratingValue: Int = 0
    var optionsList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Options"
        
        //view.backgroundColor = UIColor(hex: "#0A6ACD")
        if defaults.array(forKey: "switchON") != nil {
            optionsList = defaults.array(forKey: "switchON")  as? [Bool] ?? [Bool]()
        }
        //print(optionsList)
        else {
           
            for _ in 0...23 {
                optionsList.append(false)
            }
        }
        print("IN FSB: \(optionsList)")
        //print(ratingOn)
    
      
        
        ratingOn = defaults.bool(forKey: "ratingON")
        ratingSwitch.isOn = ratingOn
        
        
        if ratingOn {
            if defaults.value(forKey: "slidON") != nil {
                let rating = defaults.value(forKey: "slidON") as! Int
                ratingLabel.text = String(rating) + " & Up"
                ratingSlider.value = Float(rating)
            }
        }
        else {
            ratingLabel.text = ""
            ratingSlider.alpha = 0
        }
        
       
    }

    @IBAction func ratingSwitched(_ sender: Any) {
        if ratingSwitch.isOn {
            ratingOn = true
            ratingSlider.alpha = 1
            //ratingLabel.text = String("0 & Up")
            ratingLabel.text = String(Int(ratingSlider.value)) + " & Up"
            defaults.set(ratingOn, forKey: "ratingON")
        }
        else {
            ratingOn = false
            ratingSlider.alpha = 0
            ratingLabel.alpha = 0
            defaults.set(ratingOn, forKey: "ratingON")
            defaults.set(0, forKey: "slidON")
        }
    }
    
    @IBAction func ratingSlid(_ sender: Any) {
        ratingLabel.alpha = 1
        ratingLabel.text = String(Int(ratingSlider.value)) + " & Up"
        //ratingOn = true
        defaults.set(Int(ratingSlider.value), forKey: "slidON")
        tableView.reloadData()
    }
    
    func updateSwitchState(index: Int) {
        if optionsList[index] == false {
            print("Toggled to true at ", index)
            optionsList[index] = true
        }
        else {
            print("Toggled to false at ", index)
            optionsList[index] = false
        }
        defaults.set(optionsList, forKey: "switchON")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
        header.backgroundView?.backgroundColor = UIColor(hex: "#0A6ACD")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return platforms.count
        }
        if section == 1 {
            return genres.count 
        }
        if section == 2 {
            return esrb.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath) as! FilterSideBarTableViewCell
        
        // Configure the cell...
        if(indexPath.section == 0) {
            
            //set the cell and its switch
            cell.setCell(text: platforms[indexPath.row], index: indexPath, sender: self)
            cell.sideBarSwitch.isOn = optionsList[indexPath.row]
        }
        else if indexPath.section == 1 {
            
            cell.setCell(text: genres[indexPath.row], index: indexPath, sender: self)
            cell.sideBarSwitch.isOn = optionsList[indexPath.row + platforms.count]
        }
        else if indexPath.section == 2 {
            
            cell.setCell(text: esrb[indexPath.row], index: indexPath, sender: self)
            cell.sideBarSwitch.isOn = optionsList[indexPath.row + platforms.count + genres.count]
        }
        cell.selectionStyle = .none
        //cell.backgroundColor = UIColor(hex: "#86B86B")
        //cell.backgroundColor = UIColor(hex: "#C0C5CD")
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(hex: "#C0C5CD")
        }
        else {
            cell.backgroundColor = UIColor(hex: "#ffffff")
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func getOptionsList() -> [Bool] {
        return optionsList
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
        
        
        
    }
    */

}
