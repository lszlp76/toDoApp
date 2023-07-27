//
//  AddViewController.swift
//  toDoApp
//
//  Created by ulas özalp on 16.07.2023.
//

import UIKit

class AddViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titletextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    public var completion: ((String,String,Date)-> Void)?
        
 
    override func viewDidLoad() {
        super.viewDidLoad()
        titletextField.delegate = self
        bodyTextField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))

        // Do any additional setup after loading the view.
    }
    @objc func didTapSaveButton() {
        
        if let titletext = titletextField.text , !titletext.isEmpty,
           let bodyText = bodyTextField.text , !bodyText.isEmpty {
            let targetDate = datePicker.date
            
            completion?(titletext,bodyText,targetDate)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
