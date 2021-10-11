//
//  GroupSelectionViewController.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import Combine
import UIKit

extension GroupSelectionViewController {
    
    struct GroupSelectionRouterPath: RouterPathable {
        var vcType: Routable.Type {
           return GroupSelectionViewController.self
        }
        var params: RouterParameter?
        
        init(places: [RealNamePlace]) {
            params = [GroupSelectionViewController.ParamsKey.places.rawValue: places]
        }
        
        init() {
            params = nil
        }
    }
    
}

class GroupSelectionViewController: UIViewController {
    
    deinit {
        Logger.log(message: "GroupSelectionViewController is deinit")
    }
    
    enum State {
        case origin
        case helfScreen
        case fullScreen
        case dismiss
        
        func constraintContent(target: UIView)-> CGFloat {
            switch self {
            case .origin, .dismiss:
                return 0
            case .fullScreen:
                return target.frame.height - .adjustFloat(min: 70, max: 90)
            case .helfScreen:
                return target.frame.height / 2 - .adjustFloat(min: 30, max: 50)
            }
        }
        
        mutating func next() {
            if self != .helfScreen {
                self = .helfScreen
                return
            }
            self = .fullScreen
        }
    }
    
    private var anyCancellables = Set<AnyCancellable>()
    
    /// 視圖初始狀態，origin 為預設
    private var state: State = .origin {
        didSet {
            self.startAnimation(oldValue: oldValue, newValue: state)
        }
    }
    
    private let service: CoreDataService = .shared
    
//    private var indexPaths: [IndexPath]?
    private var places: [RealNamePlace]?
    
    /// 主要視覺都裝在contentView
    private let contentView: UIView = UIView()
    /// 上半部圓角View
    private lazy var topView: GroupSelectionTopView = {
        let view = GroupSelectionTopView()
        view.button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(floderCollectionList)))
        return view
    }()
    /// 背景半透明View
    private lazy var translucentView = UIView()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .rgba(rgb: 255, a: 1)
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.bounces = false
        tv.register(GroupSelectionTableViewCell.self, forCellReuseIdentifier: GroupSelectionTableViewCell.description())
        tv.register(AddNewHeaderView.self, forHeaderFooterViewReuseIdentifier: AddNewHeaderView.description())
        return tv
    }()
    /// contentView 的 bottomLayoutConstraint
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    private let toastView: ToastAlertView = ToastAlertView()
    
    convenience init(places: [RealNamePlace]?) {
        self.init()
        self.places = places
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        obsevered()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        state = .helfScreen
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setUI() {
        view.backgroundColor = .clear
        view.addSubview(translucentView)
        translucentView.fillSuperview()
        translucentView.backgroundColor = .rgba(rgb: 0, a: 0.5)
        translucentView.alpha = 0
        
        view.addSubview(contentView)
        
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        contentView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        bottomLayoutConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        bottomLayoutConstraint?.isActive = true
        
        contentView.addSubview(topView)
        topView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor)
        
        contentView.addSubview(tableView)
        tableView.anchor(top: topView.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        view.addSubview(toastView)
        toastView.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0))
        toastView.centerXTo(view.centerXAnchor)
    }
    
    
}


// MARK: Routable
extension GroupSelectionViewController: Routable {
    
    enum ParamsKey: String {
        case indexPaths
        case places
    }
    
    static func initWithParams(params: RouterParameter?) -> UIViewController {
        let vc: GroupSelectionViewController
        
        if let places = params?[ParamsKey.places.rawValue] as? [RealNamePlace] {
             vc = GroupSelectionViewController(places: places)
        }
        else {
            vc = GroupSelectionViewController()
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}


// MARK: combine observe
extension GroupSelectionViewController {
    
    private func obsevered() {
        service.contentDidChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self]
                _ in
                self?.tableView.reloadData()
            })
            .store(in: &anyCancellables)
    }
    
}


// MARK: objc / Logic
extension GroupSelectionViewController {
    
    /// 關閉視圖
    /// 自定義 動畫
    /// 動畫結束 dismissVC
    @objc
    private func dismissVC() {
        state = .dismiss
    }
    
    /// 將視圖展開為全螢幕 或是 半屏
    @objc
    private func floderCollectionList() {
        state.next()
    }
    
    /// 依照State 狀態有不同動畫
    /// - Parameters:
    ///   - oldValue: State 前一個值
    ///   - newValue: State 當前的值
    private func startAnimation(oldValue: State, newValue: State) {
        
        var duration: Double = 0
        
        var alpha: CGFloat = 1
        
        switch (oldValue, newValue) {
        case (.helfScreen, .fullScreen):
            duration = 0.15
        case (.fullScreen, .helfScreen):
            duration = 0.15
        case (.fullScreen, .dismiss):
            duration = 0.25
        case (.helfScreen, .dismiss):
            duration = 0.15
            alpha = 0
        case (.origin, .helfScreen):
            duration = 0.35
        default:
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.bottomLayoutConstraint?.constant = newValue.constraintContent(target: self.view)
            self.translucentView.alpha = alpha
            self.view.layoutIfNeeded()
        }) { isFinished in
            if isFinished && self.state == .dismiss {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func addNewList() {
        Router.shared.addNewGroupAlertController(toastView: toastView)
    }
    
}



// MARK: UITableViewDataSource
extension GroupSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupSelectionTableViewCell.description(), for: indexPath) as! GroupSelectionTableViewCell
        guard service.groupList.indices.contains(indexPath.row) else { fatalError("row is out of range")}
        
        let group = service.groupList[indexPath.row]
        
        cell.label.text = group.name
        
        return cell
    }
    
}


// MARK: UITableViewDelegate
extension GroupSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddNewHeaderView.description()) as! AddNewHeaderView
        header.tapPress = { [weak self] in
            self?.addNewList()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard service.groupList.indices.contains(indexPath.row) else { return }
        if let places = self.places {
            service.removeToGroup(places: places, groupSection: indexPath.row)
        }
        else {
            service.deleteGroup(section: indexPath.row)
        }
        dismissVC()
    }
    
    
}




