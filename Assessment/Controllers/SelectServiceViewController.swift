//
//  SelectServiceViewController.swift
//  Assessment
//
//  Created by Mac_admin on 01/12/20.
//  Copyright © 2020 Bankaks. All rights reserved.
//

import UIKit

class SelectServiceViewController: UIViewController {

    // #MARK: Outlets
    @IBOutlet weak var showServiceTextField: UITextField!
    
    // #MARK: Declarations
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let options = ["option1", "option2", "option3"]
    var typeValue = String()
    
    // #MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
    }
    
    // #MARK: Other functions
    func setupPicker() {
        self.showServiceTextField.inputView = self.pickerView
        self.showServiceTextField.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
    }
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        
        if showServiceTextField.text?.count != 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            vc.typeValue = self.typeValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let alert = UIAlertController(title: nil, message: "Please select a service to continue", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

// #MARK: Extensions
extension SelectServiceViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showServiceTextField.text = options[row]
    }
}

extension SelectServiceViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.typeValue = String(row + 1)
        self.showServiceTextField.text = options[row]
        self.showServiceTextField.resignFirstResponder()
    }

    func didTapCancel() {
        self.showServiceTextField.text = nil
        self.showServiceTextField.resignFirstResponder()
    }
}
