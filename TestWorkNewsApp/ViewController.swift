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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, UISearchBarDelegate {
    
    var searchPhrase : String?
    var selectedCategoryType : String?
    var selectedLanguageType : String?
    var selectedCountryType : String?
    
    var newsFetchManager = NewsFetchManager()
    var articlesArray = [NewsArticle]()
    var refresher: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefresher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isPagingEnabled = true
    }
    
    func setRefresher(){
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor(red: 0.08, green: 0.31, blue: 0.75, alpha: 0.7)
        refresher.addTarget(self, action: #selector(sendRequest), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setContentOffset(.zero, animated:true)
        searchPhrase = UserDefaults.standard.string(forKey: "searchPhrase")
        searchBar.text = searchPhrase
        selectedCategoryType = UserDefaults.standard.string(forKey: "categoryType")
        selectedLanguageType = UserDefaults.standard.string(forKey: "languageType")
        selectedCountryType = UserDefaults.standard.string(forKey: "countyType")
        
        sendRequest()
    }
    
    //Mark: Work with TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? CustomTableViewCell
        if articlesArray.isEmpty != true {
            cell?.authorLabel.text = articlesArray[indexPath.row].author
            cell?.titleLabel.text = articlesArray[indexPath.row].title
            cell?.sourceLabel.text = articlesArray[indexPath.row].source
            cell?.descriptionLabel.text = articlesArray[indexPath.row].description
            cell?.pictureView.sd_setImage(with: URL(string: articlesArray[indexPath.row].urlToImage ?? ""), placeholderImage: UIImage(named: "background"))
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
        if articlesArray.isEmpty != true {
            if let urlAsString = articlesArray[indexPath.row].url {
                if let url = URL(string: urlAsString) {
                    let safariLink = SFSafariViewController(url: url)
                    present(safariLink, animated: true, completion: nil)
                    safariLink.delegate = self
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableView.scrollToNearestSelectedRow(at: UITableView.ScrollPosition.top, animated: true)
    }
    
    //Mark: Work with SearchBar
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
                    self.articlesArray = resp
                    self.tableView.reloadData()
                } else if error != nil || error != "" {
                    self.showAlert(title: "Alert", message:  error ?? "Error.", action: "Ok")
                } else {
                    self.showAlert(title: "Alert", message:  "No articles for your parameters", action: "Ok")
                }
            }
        refresher.endRefreshing()
    }
    
    func showAlert(title: String, message: String, action: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

