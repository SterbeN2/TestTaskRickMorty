//
//  CardCell.swift
//  TestTask
//
//  Created by Ильнур Загитов on 06.03.2023.
//

import UIKit
import SnapKit
import Nuke

protocol CharacterDelegate: AnyObject {
    func addIdInList (sender: UIButton) -> [Int]
}

class CardCell: UICollectionViewCell {
    
    //MARK: - Public
    weak var delegate: CharacterDelegate?
    
    func configure (with info: CharacterCardData, isFavorite: Bool) {
        characterName.text = "Имя: \(info.name)"
        characterSpecies.text = "Вид: \(info.species)"
        characterGender.text = "Пол: \(info.gender)"
        characterStatus.text = "Статус: \(info.status)"
        
        checkinCharackterInList(isFavorite: isFavorite)
    }
    
    func loadImage (with info: CharacterCardData) {
        Nuke.loadImage(
            with: URL(string: info.image)!,
            into: characterImage)
    }
    
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private constants
    private enum UIConstants {
        static let imageSize: CGFloat = 300
        static let imageToCellInset: CGFloat = 20
        static let spacingBetweenElements: CGFloat = 20
        static let spaceToTheEdge: CGFloat = 16
        static let buttonToCharacterStatus: CGFloat = 50
    }
    
    //MARK: - Private properties
    
    func configForLabelBold(label: UILabel) -> UILabel{
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }
    
    private let characterImage: UIImageView = { // достаточно просто .init()
        let view = UIImageView()
        return view
    }()
    
    private let characterName: UILabel = {
        let label = UILabel()
        //configForLabelBold(label: label) // comments
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let characterSpecies: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let characterGender: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let characterStatus: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var buttonToAddFavorites: UIButton = { // lazy var из-за обращения в замыкании к self
        let button = UIButton(type: .system)
        button.backgroundColor = .blue //цвет кнопки
        button.setTitle("Добавить в избранные", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        //настройки тени
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 1.5, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 8
        button.layer.cornerRadius = 16 //округление
        
        button.addTarget(self, action: #selector(didTapOnAddFavorite), for: .touchUpInside) // xcode warning: 'self' refers to the method 'CardCell.self', which may be unexpected
        return button
    }()
}

//MARK: - Private methods
private extension CardCell {
    func checkinCharackterInList(isFavorite: Bool) {
        let titleForButton = isFavorite ? "Удалить из избранных" : "Добавить в избранные"
        buttonToAddFavorites.backgroundColor = isFavorite ? .red : .blue
        buttonToAddFavorites.setTitle(titleForButton, for: .normal)
    }
    
    func initialize() {
        contentView.addSubview(characterImage)
        characterImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(UIConstants.imageSize)
            make.top.equalToSuperview().inset(UIConstants.imageToCellInset)
        }
        
        contentView.addSubview(characterName)
        characterName.snp.makeConstraints {make in
            make.left.right.equalToSuperview().inset(UIConstants.spaceToTheEdge)
            make.top.equalTo(characterImage.snp.bottom).offset(UIConstants.spacingBetweenElements)
        }
        
        contentView.addSubview(characterSpecies)
        characterSpecies.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIConstants.spaceToTheEdge)
            make.top.equalTo(characterName.snp.bottom).offset(UIConstants.spacingBetweenElements)
        }
        
        contentView.addSubview(characterGender)
        characterGender.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIConstants.spaceToTheEdge)
            make.top.equalTo(characterSpecies.snp.bottom).offset(UIConstants.spacingBetweenElements)
        }
        
        contentView.addSubview(characterStatus)
        characterStatus.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIConstants.spaceToTheEdge)
            make.top.equalTo(characterGender.snp.bottom).offset(UIConstants.spacingBetweenElements)
        }
        
        contentView.addSubview(buttonToAddFavorites)
        buttonToAddFavorites.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(70)
            make.height.equalTo(40)
            make.top.equalTo(characterStatus.snp.bottom).offset(UIConstants.buttonToCharacterStatus)
        }
    }

    @objc func didTapOnAddFavorite(_ sender: UIButton) {
        delegate?.addIdInList(sender: sender)
    }
}

