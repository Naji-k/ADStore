//
//  NotificationTableVC.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/18/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit

class NotificationTableVC: UITableViewController {
    @IBOutlet weak var enableAllSwitch: UISwitch!
    @IBOutlet weak var messagesSwitch: UISwitch!
    @IBOutlet weak var tipsSwitch: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.isEnabled = false
        Utilities.customButtonColors(saveBtn, enableColor: UIColor(named: "TintGreenColor")!, disableColor: .lightGray, cornerRadius: 25.0, borderWidth: 1, tintColor: .white)
        
    }

    @IBAction func enableAllSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            messagesSwitch.isOn = true
            tipsSwitch.isOn = true
        } else {
            messagesSwitch.isOn = false
            tipsSwitch.isOn = false
        }
        saveBtn.isEnabled.toggle()
    }
    @IBAction func messagesSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            print("MessageOn")
        } else {
            print("MessageOFF")
        }
        saveBtn.isEnabled.toggle()
        
    }
    @IBAction func tipsSwitchTapped(_ sender: UISwitch) {
        sender.isOn ? print("TipsOn") : print("TipsOff")
        saveBtn.isEnabled.toggle()

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


}
