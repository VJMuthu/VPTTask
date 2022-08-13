//
//  ViewController.swift
//  VPTTask
//
//  Created by iOS on 12/08/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
//MARK: - Getstarted Action
    @IBAction func getstartedAction(_ sender:UIButton){
        let loginVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

}

