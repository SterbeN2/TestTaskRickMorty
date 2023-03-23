//
//  ViewControllerCharacter.swift
//  TestTask
//
//  Created by Ильнур Загитов on 02.03.2023.
//

import UIKit
import SnapKit

class ViewControllerCharacter: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        initialize()
        loadInfoAboutCharacter()
    }
    
    var favoritesList: [Int] = []
    let defaults = UserDefaults.standard
    
    //MARK: - Private properties
    private let characterID: Int
    private var character: CharacterCardData?
    private var collectionView: UICollectionView!
    private let apiManager = APIManagerForCharacterCard()
    private var isFavorite: Bool
    
    private enum UIConstants {
        static let screenSize = UIScreen.main.bounds
        static let screenWidth = screenSize.width
        static let screenHeight = screenSize.height
    }
    
    init(for characterID: Int, isFavorite: Bool) {
        self.characterID = characterID
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Private methods
private extension ViewControllerCharacter {
    func initialize() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIConstants.screenWidth) // Лишнее
            make.height.equalTo(UIConstants.screenHeight) // Лишнее
        }
    }
    
    func loadInfoAboutCharacter() {
        APIManagerForCharacterCard.shared.getInfoAboutCharacter(id: characterID) {[weak self] value in
            DispatchQueue.main.async {
                guard let self else {return}
                self.character = value
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ViewControllerCharacter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        character != nil ? 1 : 0 // можно еще через guard
        guard let character = character else {return 0}
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        cell.configure(with: character!, isFavorite: isFavorite) // force unwrap!
        cell.loadImage(with: character!) // force unwrap!
        cell.delegate = self
        return cell
        
    }
    
}

extension ViewControllerCharacter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIConstants.screenWidth, height: UIConstants.screenHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

//MARK: - CharacterDelegate
extension ViewControllerCharacter: CharacterDelegate {
    func addIdInList(sender: UIButton) -> [Int] { // название не говорящее
        var defaultsFavoritesList: [Int] = defaults.array(forKey: "id") as? [Int] ?? []
        if let index = defaultsFavoritesList.firstIndex(of: characterID) {
            defaultsFavoritesList.remove(at: index)
            sender.setTitle("Добавить в избранные", for: .normal)
            sender.backgroundColor = .blue
        } else {
            defaultsFavoritesList.append(characterID)
            sender.setTitle("Удалить из избранных", for: .normal)
            sender.backgroundColor = .red
        }
        
        defaults.set(defaultsFavoritesList, forKey: "id")
        isFavorite.toggle()
        print(defaultsFavoritesList)
        return favoritesList // эт чо? По коду не используется | hz
    }
}
