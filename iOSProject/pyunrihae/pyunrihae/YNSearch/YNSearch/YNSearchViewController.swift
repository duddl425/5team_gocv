//
//  YNSearchViewController.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//  Edited by JuneKim on 2017.8.14

import UIKit

open class YNSearchViewController: UIViewController, UITextFieldDelegate {
    open var delegate: YNSearchDelegate? {
        didSet {
            self.ynSearchView.delegate = delegate
        }
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    open var ynSearchTextfieldView: YNSearchTextFieldView!
    open var ynSearchView: YNSearchView!
    
    open var ynSearch = YNSearch()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }

    open func ynSearchinit() {
        self.ynSearchTextfieldView = YNSearchTextFieldView(frame: CGRect(x: 20, y: 64, width: width-40, height: 50))
        self.ynSearchTextfieldView.ynSearchTextField.delegate = self
        self.ynSearchTextfieldView.ynSearchTextField.addTarget(self, action: #selector(ynSearchTextfieldTextChanged(_:)), for: .editingChanged)
        self.ynSearchTextfieldView.cancelButton.addTarget(self, action: #selector(ynSearchTextfieldcancelButtonClicked), for: .touchUpInside)
        self.ynSearchTextfieldView.searchButton.addTarget(self, action: #selector(ynSearchTextfieldsearchButtonClicked), for: .touchUpInside)
        self.view.addSubview(self.ynSearchTextfieldView)
        
        self.ynSearchView = YNSearchView(frame: CGRect(x: 0, y: 114, width: width, height: height-70))
        self.view.addSubview(self.ynSearchView)
    }
    
    open func setYNCategoryButtonType(type: YNCategoryButtonType) {
        self.ynSearchView.ynSearchMainView.setYNCategoryButtonType(type: .colorful)
    }
    
    open func initData(database: [Any]) {
        self.ynSearchView.ynSearchListView.initData(database: database)
    }

    
    // MARK: - YNSearchTextfield
    open func ynSearchTextfieldcancelButtonClicked() {
        self.ynSearchTextfieldView.ynSearchTextField.text = ""
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 1
            self.ynSearchTextfieldView.cancelButton.alpha = 0
            self.ynSearchTextfieldView.searchButton.alpha = 0
            self.ynSearchView.ynSearchListView.alpha = 0
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = false
            self.ynSearchView.ynSearchListView.isHidden = true
            self.ynSearchTextfieldView.cancelButton.isHidden = true
            self.ynSearchTextfieldView.searchButton.isHidden = true

            
        }
    }
    
    
    open func ynSearchTextfieldsearchButtonClicked() {
        
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = self.ynSearchTextfieldView.ynSearchTextField.text
    }
    
    open func ynSearchTextfieldTextChanged(_ textField: UITextField) {
//        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = textField.text
    }
    
    // MARK: - UITextFieldDelegate
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if !text.isEmpty {
            self.ynSearch.appendSearchHistories(value: text)
            self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
            // return 눌렀을 때 검색이 되도록하기
            self.ynSearchView.ynSearchListView.ynSearchTextFieldText = self.ynSearchTextfieldView.ynSearchTextField.text
        }
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        return true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 0
            self.ynSearchTextfieldView.cancelButton.alpha = 1
            self.ynSearchTextfieldView.searchButton.alpha = 1
            self.ynSearchView.ynSearchListView.alpha = 1
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = true
            self.ynSearchView.ynSearchListView.isHidden = false
            self.ynSearchTextfieldView.cancelButton.isHidden = false
            self.ynSearchTextfieldView.searchButton.isHidden = false

        }
    }
}