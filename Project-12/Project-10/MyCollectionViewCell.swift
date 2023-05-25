import UIKit
class MyCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()

    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = CGRect(x: 10, y: 10, width: 120, height: 120)
        label.frame = CGRect(x: 0, y: 140, width: 140, height: 20)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        label.font = UIFont(name: "Marker Felt", size: 16)
        label.textAlignment = .center
        label.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

