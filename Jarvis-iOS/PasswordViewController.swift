//
//  PasswordViewController.swift
//  Jarvis-iOS
//
//  Created by Jason Pierna on 13/07/2017.
//  Copyright © 2017 Jason Pierna. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
	
	@IBOutlet weak var addressTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let defaults = UserDefaults.standard
		if let address = defaults.object(forKey: "ip") as? String {
			addressTextField.text = address
		}
	}
	
	@IBAction func saveAddress() {
		guard let address = addressTextField.text else {
			let alertController = UIAlertController(title: "Merci de remplir le champ", message: "Le champ ne doit pas être vide.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))
			present(alertController, animated: true)
			return
		}
		
		let defaults = UserDefaults.standard
		defaults.set(address, forKey: "ip")
		
		let alertController = UIAlertController(title: "IP enregistrée", message: "L'adresse " + address + " a bien été enregistrée.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		
		addressTextField.resignFirstResponder()
		present(alertController, animated: true)
	}
	
}

extension PasswordViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		saveAddress()
		
		return true
	}
}
