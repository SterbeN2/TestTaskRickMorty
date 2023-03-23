//
//  MainViewController.swift
//  TestTask
//
//  Created by Ильнур Загитов on 28.02.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        getListOfCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataInFavoriteList()
        tableView.reloadData()
    }
    
    //MARK: - Private properties
    private var favoriteStatus: Bool = false // Не очень ясное название
    private let tableView = UITableView()
    private var characterList: [Result] = []
    private var favoriteList: [Result] = []
    private var defaultsFavoritesList: [Int] = UserDefaults.standard.array(forKey: "id") as? [Int] ?? []
    
}

//MARK: - Private methods
private extension MainViewController {
    func initialize() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = makeRightBarButtonItem()
        navigationItem.title = "Персонажи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Для чего регистрация стандартного класса? Должен быть кастмный
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().inset(50) // Почему закоментировал? Нет вертикальной позиции| done
            make.height.equalToSuperview().inset(30)
        }
    }
    
    func makeRightBarButtonItem() -> UIBarButtonItem {
        let favoritesButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.text.square"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapOnFavoritesListButton))
        favoritesButtonItem.tintColor = favoriteStatus ? .lightGray : .systemRed
        
        return favoritesButtonItem
    }
    
    @objc func didTapOnFavoritesListButton(_ sender: UIButton) {
        favoriteStatus.toggle()
        sender.tintColor = favoriteStatus ? .lightGray : .systemRed
        self.tableView.reloadData()
    }
    
    //Обновление списка избранных
    func reloadDataInFavoriteList() {
        defaultsFavoritesList = UserDefaults.standard.array(forKey: "id") as? [Int] ?? []
        //        if defaultsFavoritesList.isEmpty {
        //            imageForTableView()
        //        } else {
        //            tableView.backgroundView = .none
        //        }
    }
    
    func imageForTableView() {
        let image = UIImage(named: "rick")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch favoriteStatus {
        case false:
            return characterList.count
        default:
            return defaultsFavoritesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! // force unwrap!
        switch favoriteStatus { // А чо тут не через switch/case? | done
        case true:
            favoriteList = characterList.filter { defaultsFavoritesList.contains($0.id)}
            cell.textLabel?.text = "\(favoriteList[indexPath.row].name)"
        default:
            let nameCharacter = characterList[indexPath.row]
            cell.textLabel?.text = "\(nameCharacter.name)"
        }
        cell.accessoryType = .disclosureIndicator //chevron
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterID: Int
        if favoriteStatus {
            favoriteList = characterList.filter { defaultsFavoritesList.contains($0.id)} // можно было вынести в вычисляемое свойство ибо повторяется | done
            characterID = favoriteList[indexPath.item].id
            
        } else {
            characterID = characterList[indexPath.item].id
        }
        
        var isCharacterFarotite: Bool = defaultsFavoritesList.contains(characterID)
//        for i in favoriteList {
//            if i.id == characterID {
//                isCharacterFarotite = true
//                break
//            }
//        }
        
        let viewController: ViewControllerCharacter = .init(for: characterID, isFavorite: isCharacterFarotite)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - API
private extension MainViewController {
    func getListOfCharacters() {
        APIManagerCharaterData.shared.getListOfCharacters { [weak self] value in
            DispatchQueue.main.async {
                guard let self else {return}
                self.characterList = value
                self.tableView.reloadData()
                                print(self.characterList)
            }
        }
    }
}
