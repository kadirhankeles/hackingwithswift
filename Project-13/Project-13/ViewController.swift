//
//  ViewController.swift
//  Project-13
//
//  Created by Kadirhan Keles on 1.05.2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private lazy var uiView: UIView = {
        let DynamicView = UIView()
        DynamicView.backgroundColor = .darkGray
        return DynamicView
        
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 355, height: 450))
        
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var uiLabel : UILabel = {
        var label = UILabel()
        label.text = "Intensity:"
        label.textColor = .black
        return label
    }()
    
    private lazy var Slider : UISlider = {
        var slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        return slider
    }()
    
    private var button1 : UIButton = {
        let button1 = UIButton(type: .system)
        button1.setTitle("change filter", for: .normal)
        button1.addTarget(self, action: #selector(filterClicked), for: .touchUpInside)
        return button1
    }()
    
    private lazy var button2 : UIButton = {
        let button2 = UIButton(type: .system)
        button2.setTitle("save", for: .normal)
        button2.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        return button2
    }()
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func filterClicked(sender: UIButton!) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
           ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           present(ac, animated: true)
    }
    
    @objc func saveClicked(sender: UIButton!) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Select a photo from the gallery", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func setFilter(action: UIAlertAction) {
        // devam etmeden önce geçerli bir görüntüye sahip olduğumuzdan emin olun!
        guard currentImage != nil else { return }

        // uyarı eyleminin başlığını güvenle okuyun
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)
        button1.setTitle(actionTitle, for: .normal)
        print(actionTitle)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.alpha = 0
            currentImage = selectedImage
            UIView.animate(withDuration: 1) {
                self.imageView.alpha = 1.0
               }
        }
        picker.dismiss(animated: true, completion: nil)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        
        applyProcessing()
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        //let value = sender.value
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(Slider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(Slider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(Slider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
               // we got back an error!
               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           } else {
               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           }
    }
    
    func setupUI() {
        view.addSubview(uiView)
        uiView.addSubview(imageView)
        view.addSubview(uiLabel)
        view.addSubview(Slider)
        view.addSubview(button1)
        view.addSubview(button2)
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        Slider.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            uiView.widthAnchor.constraint(equalToConstant: 375.0),
            uiView.heightAnchor.constraint(equalToConstant: 470.0),
            
            
            uiLabel.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 10),
            uiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            //uiLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            uiLabel.heightAnchor.constraint(equalToConstant: 20),
            uiLabel.widthAnchor.constraint(equalToConstant: 80),
            
            Slider.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 10),
            Slider.leadingAnchor.constraint(equalTo: uiLabel.trailingAnchor, constant: 10),
            Slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            Slider.centerYAnchor.constraint(equalTo: uiLabel.centerYAnchor),
            
            button1.topAnchor.constraint(equalTo: uiLabel.bottomAnchor, constant: 20),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            button1.widthAnchor.constraint(equalToConstant: 150),
            
            button2.topAnchor.constraint(equalTo: uiLabel.bottomAnchor, constant: 20),
            button2.leadingAnchor.constraint(equalTo: button1.trailingAnchor, constant: 130),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            
        ])
    }


}

/*
 var context: CIContext! -> görüntü oluşturmayı yöneten Core Image bileşenidir. Bunu burada oluşturuyoruz ve uygulamamız boyunca kullanıyoruz, çünkü bir bağlam oluşturmak hesaplama açısından pahalıdır, bu yüzden bunu sürekli yapmak istemiyoruz.
 
 var currentFilter: CIFilter! -> Çekirdek Görüntü filtresidir ve kullanıcının etkinleştirdiği filtreyi depolayacaktır. Bu filtreye, görüntü görünümünde göstermemiz için bir sonuç çıktısı vermesini istemeden önce çeşitli girdi ayarları verilecektir.
 */
