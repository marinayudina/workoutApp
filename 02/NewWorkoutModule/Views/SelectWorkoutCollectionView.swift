//
//  SelectWorkoutCollectionView.swift
//  02
//
//  Created by Марина on 14.03.2023.
//

import UIKit

protocol SelectImageProtocol: AnyObject {
    func selectImage(nameImage: String)
}
class SelectWorkoutCollectionView: UICollectionView {
    
    weak var ImageNameDelegate: SelectImageProtocol?
    
    private var lastSelectedIndexPath: IndexPath?
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    private var imageNames = ["biceps", "pullup", "pushup", "squats", "triceps"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        register(SelectWorkoutCell.self, forCellWithReuseIdentifier: SelectWorkoutCell.idSelectionWorkoutCell)
        configure()
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        self.backgroundColor = .none
        backgroundColor = .specialBrown

//        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
        
    }
    
    private func setupLayout() {
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.scrollDirection = .horizontal
    
    }
}

extension SelectWorkoutCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectWorkoutCell.idSelectionWorkoutCell, for: indexPath) as? SelectWorkoutCell else {
            return UICollectionViewCell()
        }
        let nameImage = imageNames[indexPath.row]

        cell.configure(nameImage: nameImage)
        
        if (indexPath.item == 0) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
//            lastSelectedIndexPath = indexPath
//            cell.isSelected = true
//            print(cell.isSelected)
        }
        
//        cell.isSelected = (lastSelectedIndexPath == indexPath)
        
        return cell
    }
    

}

extension SelectWorkoutCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
}

extension SelectWorkoutCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ImageNameDelegate?.selectImage(nameImage: imageNames[indexPath.row])
//        guard lastSelectedIndexPath != indexPath else { return }
//
//              if let index = lastSelectedIndexPath {
//                 let cell = collectionView.cellForItem(at: index) as! SelectWorkoutCell
//                 cell.isSelected = false
//               }
//
//               let cell = collectionView.cellForItem(at: indexPath) as! SelectWorkoutCell
//               cell.isSelected = true
//         lastSelectedIndexPath = indexPath
        

    }
}
