//
//  ViewController.swift
//  ToDo + CoreData
//
//  Created by Антон Заверуха on 23.02.2022.
//  Copyright © 2022 Антон Заверуха. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [TodoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
        
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (didTapAdd))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddPhoto))
    }
//    @objc private func didTapAddPhoto(){
//        let alert = UIAlertController(title: "Додати фото", message: "Виберіть фото", preferredStyle: .alert)
//
//               alert.addAction(UIAlertAction(title: "Зберегти", style: .cancel, handler: { [weak self](_) in
//                   guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
//                   self?.createItem(name: text)
//               }))
//               present(alert, animated: true)
//    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "Нове завдання", message: "Введіть завдання", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Зберегти", style: .cancel, handler: { [weak self](_) in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    
    // Core Data
    
    func getAllItems(){
        do{
            models = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch{
            // error
        }
        
    }
    func createItem(name: String){
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }catch{
            // error
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Змінити", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Відмінити", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Редагувати", style: .default, handler: { _ in
        
            let alert = UIAlertController(title: "Редагувати", message: "Редагувати наявне завдання", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Зберегти", style: .cancel, handler: { [weak self](_) in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {return}
                self?.updateItem(item: item, newName: newName)
            }))
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Видалити", style: .destructive, handler: {[weak self] _ in
            self?.deleteItem(item: item)
        }))
            present(sheet, animated: true)
    }
    
    func deleteItem(item: TodoListItem){
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        }catch{
            // error
        }
    }
    func updateItem(item: TodoListItem, newName: String){
        item.name = newName
        
        do{
            try context.save()
            getAllItems()
        }catch{
            // error
        }
    }


}

