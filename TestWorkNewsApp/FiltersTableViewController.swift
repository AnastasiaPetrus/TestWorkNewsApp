//
//  FiltersTableViewController.swift
//  TestWorkNewsApp
//
//  Created by Anastasia on 8/23/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categoriesArray: Array = ["", "business", "entertainment", "general", "health", "science", "sports", "technology"]
    let languagesArray: Array = ["", "ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "se", "ud", "zh"]
    let countriesArray: Array = ["", "ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    
    var selectedCategoryNumber : Int?
    var selectedLanguageNumber : Int?
    var selectedCountryNumber : Int?
    
    var selectedCategoryType : String?
    var selectedLanguageType : String?
    var selectedCountryType : String?
    
    @IBOutlet var categoryType: UIPickerView!
    @IBOutlet var languageType: UIPickerView!
    @IBOutlet var countyType: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedCategoryNumber = UserDefaults.standard.integer(forKey: "categoryTypeNumber")
        selectedLanguageNumber = UserDefaults.standard.integer(forKey: "languageTypeNumber")
        selectedCountryNumber = UserDefaults.standard.integer(forKey: "countyTypeNumber")
        
        categoryType.selectRow(selectedCategoryNumber ?? 0, inComponent: 0, animated: true)
        languageType.selectRow(selectedLanguageNumber ?? 0, inComponent: 0, animated: true)
        countyType.selectRow(selectedCountryNumber ?? 0, inComponent: 0, animated: true)
    }
    
    func wasSelectedAnotherTypeForSearching(nameOfType: String, arrayOfVarsOfType: [String], numberOfSelectedVar: Int){
        if numberOfSelectedVar == 0 {
            UserDefaults.standard.removeObject(forKey: nameOfType)
        } else {
            UserDefaults.standard.set(arrayOfVarsOfType[numberOfSelectedVar], forKey: nameOfType)
        }
        UserDefaults.standard.set(numberOfSelectedVar, forKey: nameOfType + "Number")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case categoryType:
            return categoriesArray.count
        case languageType:
            return languagesArray.count
        case countyType:
            return countriesArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case categoryType:
            return "\(categoriesArray[row])"
        case languageType:
            return "\(languagesArray[row])"
        case countyType:
            return "\(countriesArray[row])"
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryType:
            
            selectedCategoryNumber = row
            selectedCategoryType = categoriesArray[row]
            wasSelectedAnotherTypeForSearching(nameOfType: "categoryType", arrayOfVarsOfType: categoriesArray, numberOfSelectedVar: row)
        case languageType:
            
            selectedLanguageNumber = row
            selectedLanguageType = languagesArray[row]
            wasSelectedAnotherTypeForSearching(nameOfType: "languageType", arrayOfVarsOfType: languagesArray, numberOfSelectedVar: row)
        case countyType:
            
            selectedCountryNumber = row
            selectedCountryType = countriesArray[row]
            wasSelectedAnotherTypeForSearching(nameOfType: "countryType", arrayOfVarsOfType: countriesArray, numberOfSelectedVar: row)
        default:
            print("no one was selected")
        }
    }
}
