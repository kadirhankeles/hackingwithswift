//
//  ViewController.swift
//  Milestone Projects 10-12
//
//  Created by Kadirhan Keles on 27.04.2023.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [CustomPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        loadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        tableView = UITableView(frame: .zero, style: .plain)
        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        
       
            
    }
    
    @objc func addImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func showCaptionAlert(forImage: String) {
        let ac = UIAlertController(title: "Title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let title = ac.textFields?.first?.text {
                let customPhoto = CustomPhoto(image: forImage, title: title)
                self.photos.append(customPhoto)
                self.savePhoto()
                self.tableView.reloadData()
            }
        }))
        present(ac, animated: true)
    }
    
    func savePhoto() {
        
        if let savedPhotos = try? JSONEncoder().encode(photos) {
            UserDefaults.standard.set(savedPhotos, forKey: "photo")
        }else {
            print("Failed to save photo")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        if let photosData = UserDefaults.standard.data(forKey: "photo") {
            do {
                photos = try JSONDecoder().decode([CustomPhoto].self, from: photosData)
            } catch {
                print("Failed to load photo")
            }
        }
        tableView.reloadData()
    }
    
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let photo = photos[indexPath.row]
        content.text = photo.title
        print(photo.image)
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(selectedPhoto.image).path)
        detailVC.imageTitle = selectedPhoto.title
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imageName = UUID().uuidString
            let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = selectedImage.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
            
            picker.dismiss(animated: true,completion: nil)
            self.showCaptionAlert(forImage: imageName)
            
            
            
        }
    }
    
    
    
}

