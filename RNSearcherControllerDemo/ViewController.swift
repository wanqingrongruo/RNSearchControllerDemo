//
//  ViewController.swift
//  RNSearcherControllerDemo
//
//  Created by 婉卿容若 on 16/8/9.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - properties - 即定义的各种属性
    
    var tableView: UITableView! // tableView
    var dataSource = [
        Candy(category:"Chocolate", name:"Chocolate Bar"),
        Candy(category:"Chocolate", name:"Chocolate Chip"),
        Candy(category:"Chocolate", name:"Dark Chocolate"),
        Candy(category:"Hard", name:"Lollipop"),
        Candy(category:"Hard", name:"Candy Cane"),
        Candy(category:"Hard", name:"Jaw Breaker"),
        Candy(category:"Other", name:"Caramel"),
        Candy(category:"Other", name:"Sour Chew"),
        Candy(category:"Other", name:"Gummi Bear")
    ]

    
    var searchController: UISearchController! // 搜索vc
    var searchResultsController: UITableViewController! // 搜索结果vc
    var searchResults:Array = [Candy]() //搜索结果
    
    
    // MARK: -  Life cycle - 即生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "search"
        view.backgroundColor = UIColor.red
        
        setUpTableView()
        setupSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit{
        
        
    }
    
}

// MARK: - Public Methods - 即系统提供的方法

extension ViewController{
    
}

// MARK: - Private Methods - 即私人写的方法

extension ViewController{
 
    func setUpTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentOffset = CGPoint(x: 0,y: 44)
        
        view.addSubview(tableView)
    }

    func setupSearchController (){
        
        searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
       // searchResultsController.tableView.rowHeight = 63
        searchResultsController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LogCell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true // 保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上
        
        
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self

    }
    
    // 搜索数据
    func filterResultsWithSearchString(_ searchString: String, scope: String = "All"){
        
        searchResults = dataSource.filter { candy in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            return categoryMatch && candy.name.lowercased().contains(searchString.lowercased()    )
        }
        searchResultsController.tableView.reloadData()
    }

}

// MARK: - Event response - 按钮/手势等事件的回应方法

extension  ViewController{
    
}

// MARK: - Delegates - 即各种代理方法

// UITableViewDelegate && UITableViewDataSource

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if searchController.isActive {
            return searchResults.count
        }else{
            return dataSource.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        var  cell: UITableViewCell!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Logcell")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Logcell")
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
            }
        }
        
        let candy:Candy
        if searchController.isActive {
            candy = searchResults[indexPath.row]
        }else{
            candy = dataSource[indexPath.row]
        }
        
        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title: String!
        if searchController.isActive{
           title =  searchResults[indexPath.row].name
        }else{
            title = dataSource[indexPath.row].name
        }
        
        let detailVC = RNDetailViewController()
        detailVC.myTitle = title
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterResultsWithSearchString(searchController.searchBar.text!, scope: scope)

    }
    
}

//  UISearchBarDelegate

extension ViewController:  UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterResultsWithSearchString(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
