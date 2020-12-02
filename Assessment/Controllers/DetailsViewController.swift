//
//  DetailsViewController.swift
//  Assessment
//
//  Created by Mac_admin on 01/12/20.
//  Copyright © 2020 Bankaks. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // #MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
    
    // #MARK: Declarations
    var typeValue = String()
    var detailsViewModel = DetailsViewModel()
    let pickerView = ToolbarPickerView()
    var textFieldTag = Int()
    var valuesForPicker = [String]()
    var userEntryArray = [String]()
    
    // #MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detailsViewModel.detailsViewController = self
        detailsViewModel.getDetailsData()
    }
    
    // #MARK: Other functions
    func setupUI() {
        DispatchQueue.main.async {
            if !self.detailsViewModel.serviceDetailsArray.isEmpty {
                self.titleLabel.text = self.detailsViewModel.serviceDetailsArray[0].result?.screen_title
            }
        }
    }
    
}

// #MARK: Extensions
extension DetailsViewController : UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // #MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !detailsViewModel.serviceDetailsArray.isEmpty {
            let count = detailsViewModel.serviceDetailsArray[0].result?.fields?.count ?? 0
            return count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if detailsViewModel.serviceDetailsArray[0].result?.fields?.count == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProceedTableViewCell", for: indexPath) as? ProceedTableViewCell
            cell?.proceedButton.addTarget(self, action: #selector(performProceedAction), for: .touchDown)
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as? DetailsTableViewCell
        let fieldAtIndex = detailsViewModel.serviceDetailsArray[0].result?.fields?[indexPath.row]
        cell?.nameTextField.delegate = self
        cell?.nameLabel.text = fieldAtIndex?.name
        cell?.nameTextField.placeholder = fieldAtIndex?.placeholder
        if fieldAtIndex?.ui_type?.type == "dropdown" {
            cell?.nameTextField.addTarget(self, action: #selector(performDropdown), for: .touchDown)
            cell?.nameTextField.tag = indexPath.row
        }
        
        return cell!
    }
    
    // #MARK: TextField functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.performDropdown(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userEntryArray.insert(textField.text ?? "", at: textField.tag)
    }
    
    
    // #MARK: Other functions
    
    func validation() -> Bool {
        let field = detailsViewModel.serviceDetailsArray[0].result?.fields
        for (count,i) in userEntryArray.enumerated() {
            if field?[count].regex != "" {
                if self.isValidString(text: i, regex: field?[count].regex ?? "") == false || i == "" {
                    return false
                }
            }
        }
        return true
    }
    
    func isValidString(text:String, regex: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: text)
    }
    
    @objc func performDropdown(_ sender: UITextField) {
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let currentCell = detailsTableView.cellForRow(at: indexPath as IndexPath)! as! DetailsTableViewCell
        self.textFieldTag = indexPath.row
        currentCell.nameTextField.inputView = self.pickerView
        currentCell.nameTextField.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        
        if let val = detailsViewModel.serviceDetailsArray[0].result?.fields?[textFieldTag].ui_type?.values {
            for i in val {
                valuesForPicker.append(i.name ?? "")
            }
        }
        
        self.pickerView.reloadAllComponents()
    }

    @objc func performProceedAction(_ sender: UIButton) {
//        if validation() {
            let alert = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)

            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
//        } else {
//            let alert = UIAlertController(title: nil, message: "Oops! Seems like the entered data is not valid. Please check all the fields", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
}

// #MARK: Extensions
extension DetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valuesForPicker.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valuesForPicker[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = NSIndexPath(row: textFieldTag, section: 0)
        let currentCell = detailsTableView.cellForRow(at: indexPath as IndexPath)! as! DetailsTableViewCell
        currentCell.nameTextField.text = valuesForPicker[row]
    }
}

extension DetailsViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.typeValue = String(row + 1)
        let indexPath = NSIndexPath(row: textFieldTag, section: 0)
        let currentCell = detailsTableView.cellForRow(at: indexPath as IndexPath)! as! DetailsTableViewCell
        currentCell.nameTextField.text = valuesForPicker[row]
        currentCell.nameTextField.resignFirstResponder()
    }

    func didTapCancel() {
        let indexPath = NSIndexPath(row: textFieldTag, section: 0)
        let currentCell = detailsTableView.cellForRow(at: indexPath as IndexPath)! as! DetailsTableViewCell
        currentCell.nameTextField.text = nil
        currentCell.nameTextField.resignFirstResponder()
    }
}
