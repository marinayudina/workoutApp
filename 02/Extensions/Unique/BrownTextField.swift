//
//  BrownTextField.swift
//  02
//
//  Created by Марина on 06.03.2023.
//

import UIKit

protocol BrownTextFieldProtocol: AnyObject {
    func typing(range: NSRange, replacementString: String)
    func clear()
}

class BrownTextField: UITextField {
    
    weak var brownDelegate: BrownTextFieldProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .specialBrown
        borderStyle = .none
        layer.cornerRadius = 10
        textColor = .specialGray
        font = .robotoBold20()
        leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 15,
                                                  height: 0))
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .done
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - UITextFieldDelegate

extension BrownTextField: UITextFieldDelegate {

    //function textFieldShouldReturn
    //runs when the return key in the keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // resignFirstResponder tells the text field that it will stop being the first responder of the window, and also hides the keyboard for the text field
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {//срабатывает при вводе текста
        brownDelegate?.typing(range: range, replacementString: string)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        brownDelegate?.clear()
        return true
    }
}
