//
//  ViewController.swift
//  avito_myTestTask
//
//  Created by Petar Perich on 31.08.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var avito: Avito?
    let dataFetcher = DataFetcher()

    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)

    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "No connection", message: "Check your internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        dataFetcher.fetchData { (response) in
            self.avito = response
            if self.avito == nil{
                self.showAlert()
            }else{
                self.tableView.reloadData()
            }
            
        }
       
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        avito?.company.employees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCustomTableViewCell
    
        let list = avito?.company.employees
        let sortedList = list?.sorted { $0.name < $1.name}
        
        
        cell.nameLabel.text = sortedList?[indexPath.row].name
        cell.phoneLabel.text = sortedList?[indexPath.row].phoneNumber
        cell.skillsLabel.text = sortedList?[indexPath.row].skills.joined(separator: ", ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

