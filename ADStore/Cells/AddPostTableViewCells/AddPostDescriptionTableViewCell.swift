//
//  AddPostDescriptionTableViewCell.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/8/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class AddPostDescriptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionTextField: UITextField!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var catogoryTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let titles = ["0", "1", "2", "3"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.catogoryTextField.addTarget(self, action: #selector(self.openListPickerVC(_:)), for: UIControl.Event.touchDragInside)
        self.conditionTextField.inputView = self.pickerView
        self.conditionTextField.inputAccessoryView = self.pickerView.toolbar
        //ToolBarPickerView Delegate
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
    }
    
    @objc func openListPickerVC(_ sender: UIButton) {
        print("categoryPressed")
        let vc : PodViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PodViewController") as! PodViewController
            self.window?.rootViewController?.present(vc, animated: true, completion: nil)


    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

}
// MARK: PickerView Delegate
extension AddPostDescriptionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.conditionTextField.text = self.titles[row]
    }
    
}
extension AddPostDescriptionTableViewCell: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
//        self.categoryLabel.text = self.titles[row]
        self.conditionTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.conditionTextField.text = nil
        self.conditionTextField.resignFirstResponder()
    }
    
    
}
