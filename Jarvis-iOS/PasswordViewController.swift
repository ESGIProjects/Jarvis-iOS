//
//  PasswordViewController.swift
//  Jarvis-iOS
//
//  Created by Jason Pierna on 13/07/2017.
//  Copyright © 2017 Jason Pierna. All rights reserved.
//

import UIKit

import PKHUD
import Alamofire

class PasswordViewController: UIViewController {
	
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	@IBAction func disableAlarm() {
		
		guard let password = passwordTextField.text else {
			let alertController = UIAlertController(title: "Merci de remplir le champ", message: "Le champ ne doit pas être vide.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))
			present(alertController, animated: true)
			return
		}
		
		// 1. Vérifier qu'une IP est enregistrée
		
		let defaults = UserDefaults.standard
		guard let address = defaults.object(forKey: "ip") as? String else {
			let alertController = UIAlertController(title: "Adresse IP nécessaire", message: "Merci de renseigner une adresse IP dans les réglages.", preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "OK", style: .default) { action in
				
			}
			
			alertController.addAction(okAction)
			present(alertController, animated: true)
			return
		}
		
		let url = "http://" + address
		
		// 2. Démarrer le wait
		passwordTextField.resignFirstResponder()
		HUD.show(.labeledProgress(title: "Désactivation…", subtitle: nil))
		
		// 3. Envoyer la requête
		let headers = [
			"Content-Type" : "application/x-www-form-urlencoded"
		]
		
		let parameters = [
			"password" : password
		]
		
		Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseString(completionHandler: { response in
			switch response.result {
			case .success(let value):
				print(value)
				DispatchQueue.main.async {
					HUD.flash(.success)
				}
			case .failure(let error):
				print(error)
				DispatchQueue.main.async {
					HUD.flash(.error)
				}
			}
		})
		
	}
	
}

extension PasswordViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		disableAlarm()
		return true
	}
}
