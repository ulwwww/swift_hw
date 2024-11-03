//
//  GenerateCatViewController.swift
//  swift_hw1
//
//  Created by ulwww on 03.11.2024.
//

import UIKit

final class GenerateCatViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var entryText: UITextField!
    @IBOutlet weak var imageLabel: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad();
        print(#function)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    @IBOutlet weak var catImageLabel: UIImageView!
    @IBAction func tapButtonForSC1(_ sender: Any) {
        if let text = entryText.text, !text.isEmpty {
            downloadCat()
        } else {
            loadRandomCat()
        }
    }
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }
    
    private func downloadCat() {
        guard let text = entryText.text, !text.isEmpty else {
            return
        }
        
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        
        guard let url = URL(string: "https://cataas.com/cat/says/\(encodedText)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imgData = data
                self?.updateImageView(with: data)
            }
        }
        
        task.resume()
    }
    private var imgData: Data?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showSegueCat" {
            guard
                let viewController: SecondVC = segue.destination as? SecondVC,
                let imgData = imgData
            else {
                return
            }
            
            viewController.setInput(with: SecondVCInput(imageData: imgData))
        }
    }
    
    private func loadRandomCat() {
            guard let url = URL(string: "https://cataas.com/cat") else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching random cat image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }


                DispatchQueue.main.async { [weak self] in
                    self?.imgData = data
                    self?.performSegue(withIdentifier: "showSegueCat", sender: self)
                }
            }
            
            task.resume()
        }
    
    private func updateImageView(with data: Data) {
            if let image = UIImage(data: data) {
                imageLabel.image = image
            }
        }

}
