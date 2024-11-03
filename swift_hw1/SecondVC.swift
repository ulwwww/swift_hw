//
//  SecondViewController.swift
//  swift_hw1
//
//  Created by ulwww on 03.11.2024.
//

import UIKit

struct SecondVCInput {
    let imageData: Data
}

final class SecondVC: UIViewController {
    
    
    @IBOutlet weak var imageCat: UIImageView!
    private var input: SecondVCInput?
    
    func setInput(with input: SecondVCInput) {
        self.input = input
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        if let input = input {
            imageCat.image = UIImage(data: input.imageData)
        }
    }
    
}

