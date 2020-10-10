//
//  ToolbarPickerView.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/8/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit
import Foundation

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
         let toolBar = UIToolbar()
         toolBar.barStyle = UIBarStyle.default
         toolBar.isTranslucent = true
         toolBar.tintColor = .black
         toolBar.sizeToFit()

         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
         let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

         toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
         toolBar.isUserInteractionEnabled = true

         self.toolbar = toolBar
     }
    
    @objc func doneTapped() {
         self.toolbarDelegate?.didTapDone()
     }

     @objc func cancelTapped() {
         self.toolbarDelegate?.didTapCancel()
     }
}
