//
//  ItemDetailViewController.swift
//  ToDo
//
//  Created by GUAN on 2019/3/1.
//  Copyright © 2019 GUAN. All rights reserved.
//

import Foundation
import UIKit
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem)
}
class ItemDetailViewController: UITableViewController,UITextFieldDelegate{
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    var datePickerVisible = false
    func showDatePicker() {
        datePicker.setDate(dueDate, animated: false)
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    }
    var dueDate = Date()
    // MARK:- Helper Methods
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    override func tableView(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            if indexPath.section == 1 && indexPath.row == 2 {
                return datePickerCell
            } else {
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
    }
    override func tableView(_ tableView: UITableView,
                               numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView,
                                   numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView,
                               heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView,
                               didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            showDatePicker()
        }
    }
    override func tableView(_ tableView: UITableView,
                               indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView,
                               indentationLevelForRowAt: newIndexPath)
    }
    
    @IBOutlet weak var textField: UITextField!
    weak var delegate: ItemDetailViewControllerDelegate?
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                               willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    //MARK: -first responder
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    // MARK:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        doneBarButton.isEnabled = (newText.count > 0)
        
        return true
    }
    //MARK:-Edit Item
    var itemToEdit: ChecklistItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text =  item.text
            doneBarButton.isEnabled = true  //recoverEnabled
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
}
