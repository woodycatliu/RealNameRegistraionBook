//
//  SMSStorageViewController.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import UIKit
import MessageUI
import Combine

// MARK: Routable
extension SMSStorageViewController: Routable {
    
    struct SMSStorageRouterPath: RouterPathable {
        var vcType: Routable.Type {
            return SMSStorageViewController.self
        }
        var params: RouterParameter? = nil
    }
    
    static func initWithParams(params: RouterParameter?) -> UIViewController {
        return UINavigationController(rootViewController: SMSStorageViewController())
    }
    
}


class SMSStorageViewController: UIViewController {
    
    struct Color {
        static let yellow: UIColor = .init(hex: "FDCA40")
        static let green: UIColor = .init(hex: "00EAD3")
        static let blue: UIColor = .init(hex: "5C7AEA")
        static let puple: UIColor = .init(hex: "CAB8FF")
        static let pink: UIColor = .init(hex: "FF449F")
        static let gray: UIColor = .init(hex: "AFAFAF")
        static let cardColors: [UIColor] = [Color.yellow, Color.green, Color.blue, Color.puple, Color.pink, Color.gray].shuffled()
    }
    
    private var anyCancellables = Set<AnyCancellable>()
    
    private let toastView: ToastAlertView = ToastAlertView()
    
    private let stackView: UIStackView = {
       let sv = UIStackView()
        sv.distribution = .fill
        sv.alignment = .fill
        sv.axis = .horizontal
        return sv
    }()
        
    lazy var service: CoreDataService = {
        let service = CoreDataService.shared
        service.contentDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.selectionCache.removeAll()
                self?.viewModel.pettern = .normal
                self?.collectionView.reloadData()
            }
            .store(in: &anyCancellables)
        return service
    }()
    
    private lazy var viewModel: SMSStorageCellViewModel = {
        let vm = SMSStorageCellViewModel()
        vm.$pettern
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationItem.rightBarButtonItems?[0].isEnabled = $0 == .normal
                self?.navigationItem.rightBarButtonItems?[1].title = ($0 == .normal) ? "選取".localized() : "完成".localized()
                self?.tabBarController?.tabBar.isHidden = $0 == .selection
                self?.menuView.isHidden = $0 == .normal
            }.store(in: &anyCancellables)
        return vm
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.register(SMSStorageCollectionViewCell.self, forCellWithReuseIdentifier: SMSStorageCollectionViewCell.description())
        cv.register(SMSStorageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SMSStorageHeaderView.description())
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        cv.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    private lazy var menuView: SMSStorageEditMenuView = {
        let view = SMSStorageEditMenuView()
        view.isHidden = true
        view.deletePress = { [weak self] in
            self?.deleteSelected()
        }
        
        view.movePress = { [weak self] in
            self?.selectedMove()
        }
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAdsadapter.shared.register(vc: self, type: .main)
    }
    
    private func setNavigation() {
        let selectionBarItem = UIBarButtonItem(title: "選取".localized(), style: .plain, target: self, action: #selector(toggleSelection))
        
        selectionBarItem.tintColor = AppSetting.Color.white
        
        let addBarItem = UIBarButtonItem(image: .init(systemName: "folder.badge.gear")?.imgWithNewSize(size: .init(width: 40, height: 30))?.tinted(color: AppSetting.Color.textSecondDark), style: .done, target: self, action: #selector(addGroupAction))
        
        addBarItem.tintColor = AppSetting.Color.white
        
        navigationItem.rightBarButtonItems = [addBarItem, selectionBarItem]
    }
    
    private func configure() {
        view.backgroundColor = AppSetting.Color.white
        let effectColorView = UIView()
        view.addSubview(effectColorView)
        effectColorView.backgroundColor = AppSetting.Color.mainBlue.withAlphaComponent(0.25)
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: stackView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        view.addSubview(toastView)
        toastView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 30, right: 0))
        toastView.centerXTo(view.centerXAnchor)
        
        view.addSubview(menuView)
        menuView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        effectColorView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: menuView.bottomAnchor, trailing: view.trailingAnchor)

    }
    
    
}

// MARK: logic
extension SMSStorageViewController {
    
    @objc
    private func addGroupAction() {
        Router.shared.editGroupAlertController(toastView: toastView)
    }
    
    @objc
    private func toggleSelection() {
        viewModel.toggleSelection()
    }
    
    private func selectedMove() {
        let indexPaths = Array(viewModel.selectionCache)
        let places = service.getPlaces(indexPaths)
        guard !places.isEmpty else { return }
        
        Router.shared.showGroupSelectionViewController(places: places)
    }
    
    private func deleteSelected() {
        viewModel.deleteSelected()
    }
    
    
}

// MARK: UICollectionViewDelegate
extension SMSStorageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SMSStorageHeaderView.description(), for: indexPath) as! SMSStorageHeaderView
        if let group = service.getGroup(indexPath.section),
           let name = group.name {
            header.label.text = name + " (\(group.placeList.count))"
            header.sectionIsOpening(group.isOpening)
        }
        
        header.viewModel = viewModel
        header.delegate = self
        header.indexPath = indexPath
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.pettern == .selection {
            if let index = viewModel.selectionCache.firstIndex(where: { $0 == indexPath }) {
                viewModel.selectionCache.remove(at: index)
                return
            }
            viewModel.selectionCache.insert(indexPath)
            return
        }
        
        if let place = service.getPlace(indexPath),
           let message = place.message {
            send1922(message: message)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let place = service.getPlace(indexPath) else { return nil }
        let color = Color.cardColors[indexPath.row % Color.cardColors.count]
        let identifier = place.objectID
        
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: { PreviewViewViewController(place: place, color: color) }, actionProvider: { _ in
            return self.makeMenu(indexPath: indexPath)
        })
        
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTagetPreview(configuration: configuration)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTagetPreview(configuration: configuration)
    }
    
    private func makeTagetPreview(configuration: UIContextMenuConfiguration)-> UITargetedPreview?  {
        let identifier = configuration.identifier
        guard let place = service.object(with: identifier),
              let indexPath = service.placeIndex(place: place),
              let cell = collectionView.cellForItem(at: indexPath) as? SMSStorageCollectionViewCell
        else { return nil }
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: cell.cardView, parameters: parameters)
    }
}

// MARK: UICollectionViewDataSource
extension SMSStorageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return service.groupList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let group = service.getGroup(section),
           !group.isOpening {
            return 0
        }
        
        return service.groupList[section].placeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SMSStorageCollectionViewCell.description(), for: indexPath) as! SMSStorageCollectionViewCell
        
        cell.viewModel = viewModel
        cell.indexPath = indexPath
        
        let color = Color.cardColors[indexPath.row % Color.cardColors.count]
        
        cell.cardView.backgroundColor = color
        
        let place = service.getPlace(indexPath)
        
        cell.titleLabel.text = place?.name ?? "長按編輯"
        
        cell.contentLabel.text = place?.regex()
        
        return cell
    }
    
}

// MARK: SMSStorageHeaderViewDelegate
extension SMSStorageViewController: SMSStorageHeaderViewDelegate {
    
    func didTapHeader(headerView: SMSStorageHeaderView, indexPath: IndexPath?) {
        guard let indexPath = indexPath,
              let group = service.getGroup(indexPath.section)
        else { return }
        group.isOpening.toggle()
        collectionView.reloadData()
        
    }
    
}

// MARK: MFMessageComposeViewControllerDelegate
extension SMSStorageViewController: Send1922Protocol, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
}

// MARK: ADS
extension SMSStorageViewController: ViewControllerAdsDelegae {
    
    func addBannerViewToView(bannerView: BannerView) {
        stackView.addArrangedSubview(bannerView)
    }
}


// MARK: maker
extension SMSStorageViewController {
    
    private func createLayout()-> UICollectionViewLayout {
        
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 2 * 4.5 / 7))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let spacing = UIScreen.main.bounds.width * 0.1 / 3
            item.edgeSpacing = .init(leading: .fixed(spacing), top: .flexible(10), trailing: .fixed(0), bottom: .flexible(10))
            
            item.contentInsets = .zero
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5 * 4.6 / 7))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            header.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
    }
    
    
    private func makeMenu(indexPath: IndexPath)-> UIMenu {
        
        let rename = UIAction(title: "更改名稱".localized(), image: UIImage(systemName: "square.and.pencil")?.tinted(color: AppSetting.Color.mainBlue)) { action in
            Router.shared.renameAlertController(indexPath: indexPath)
        }
        
        let move = UIAction(title: "移動到".localized(), image: UIImage(systemName: "folder.badge.gear")?.tinted(color: AppSetting.Color.mainBlue)) { [weak self] action in
            guard let self = self else { return }
            let places = self.service.getPlaces([indexPath])
            Router.shared.showGroupSelectionViewController(places: places)
        }
        
        
        let delete = UIAction(title: "刪除".localized(), image: UIImage(systemName: "trash")?.tinted(color: AppSetting.Color.mainBlue)) { action in
            CoreDataService.shared.deletePlace(indexPath: indexPath)
        }
        
        return UIMenu(title: "", children: [rename, move, delete])
    }
    
}
