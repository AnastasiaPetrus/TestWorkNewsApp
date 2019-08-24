//
//  ViewController.swift
//  TestWorkNewsApp
//
//  Created by Anastasia on 8/23/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, UISearchBarDelegate { var searchPhrase : String?
    var selectedCategoryType : String?
    var selectedLanguageType : String?
    var selectedCountryType : String?
    
    var newsFetchManager = NewsFetchManager()
    var dictionaryWithResponseData = [NewsArticle]()
    var refrecher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefresher()
        sendRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isPagingEnabled = true
    }
    
    func setRefresher(){
        refrecher = UIRefreshControl()
        tableView.addSubview(refrecher)
        refrecher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refrecher.tintColor = UIColor(red: 0.08, green: 0.31, blue: 0.75, alpha: 0.7)
        refrecher.addTarget(self, action: #selector(sendRequest), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setContentOffset(.zero, animated:true)
        searchPhrase = UserDefaults.standard.string(forKey: "searchPhrase")
         searchBar.text = searchPhrase
        selectedCategoryType = UserDefaults.standard.string(forKey: "categoryType")
        selectedLanguageType = UserDefaults.standard.string(forKey: "languageType")
        selectedCountryType = UserDefaults.standard.string(forKey: "countyType")
        checkIfTypeWasChanged()
    }

    
    func checkIfTypeWasChanged(){
        if searchPhrase != nil || selectedCategoryType != nil || selectedLanguageType != nil || selectedCountryType != nil {
            sendRequest()
        }
    }
    
    //Mark: Work with TableView
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryWithResponseData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? CustomTableViewCell
        if dictionaryWithResponseData.isEmpty != true {
            cell?.authorLabel.text = dictionaryWithResponseData[indexPath.row].author
            cell?.titleLabel.text = dictionaryWithResponseData[indexPath.row].title
            cell?.sourceLabel.text = dictionaryWithResponseData[indexPath.row].source
            cell?.descriptionLabel.text = dictionaryWithResponseData[indexPath.row].description
            cell?.pictureView.sd_setImage(with: URL(string: dictionaryWithResponseData[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "background"))
        } else {
            cell?.authorLabel.text = ""
            cell?.titleLabel.text = ""
            cell?.sourceLabel.text = ""
            cell?.descriptionLabel.text = "No articles."
            cell?.pictureView =  UIImageView(image: UIImage(named: "background"))
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if dictionaryWithResponseData.isEmpty != true {
            if let urlAsString = dictionaryWithResponseData[indexPath.row].url {
                if let url = URL(string: urlAsString) {
                    let safariLink = SFSafariViewController(url: url)
                    present(safariLink, animated: true, completion: nil)
                    safariLink.delegate = self
                }
            }
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        tableView.tableHeaderView = searchBar
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        tableView.tableHeaderView = nil
//    }
    
    
    //Mark: Work with SearchBar
    @IBOutlet var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.endEditing(true)
        if searchBar.text?.isEmpty != true {
            searchPhrase = searchBar.text ?? UserDefaults.standard.string(forKey: "searchPhrase")
            UserDefaults.standard.set(searchPhrase, forKey: "searchPhrase")
            sendRequest()
        } else {
            showAlert(title: "Alert", message:  "Empty search request field.", action: "Ok")
        }
    }
    
    @objc func sendRequest(){
        newsFetchManager.generateURL(searchPhrase: searchPhrase, categoryType: selectedCategoryType, languageType: selectedLanguageType, countryType: selectedCountryType) { (response, error) in
                if let resp = response, error == nil || error == "" {
                    self.dictionaryWithResponseData = resp
                    self.tableView.reloadData()
                } else if error != nil || error != "" {
                    self.showAlert(title: "Alert", message:  error ?? "Error.", action: "Ok")
                } else {
                    self.showAlert(title: "Alert", message:  "No articles for your parameters", action: "Ok")
                }
            }
        refrecher.endRefreshing()
    }
    
    func showAlert(title: String, message: String, action: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        tableView.isPagingEnabled = false
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        tableView.isPagingEnabled = true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

