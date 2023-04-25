//
//  ViewController.swift
//  Project-10
//
//  Created by Kadirhan Keles on 24.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var people = [Person]()
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        // UICollectionViewLayout oluşturun
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 140, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10 // satır aralığı
        layout.minimumInteritemSpacing = 10 // elemanlar arasındaki boşluk
        
        // UICollectionView oluşturun
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // UICollectionView'i görüntüleyin
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
        
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        let person = people[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.label.text = person.name
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Choose an action", message: nil, preferredStyle: .actionSheet)
        
        // Rename Person action
        let renameAction = UIAlertAction(title: "Rename Person", style: .default) { [weak self] _ in
            let renameAlert = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            renameAlert.addTextField()
            
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak renameAlert] _ in
                guard let newName = renameAlert?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView?.reloadData()
            })
            
            self?.present(renameAlert, animated: true)
        }
        
        // Delete Person action
        let deleteAction = UIAlertAction(title: "Delete Person", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView?.reloadData()
            print("Silindi")
        }
        
        ac.addAction(renameAction)
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = selectedImage.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
        dismiss(animated: true)
    }
    
}


