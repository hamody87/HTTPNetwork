//
//  ViewController.swift
//  HTTPNetwork
//
//  Created by Muhammad Jbara on 06/08/2021.
//

import UIKit

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseId", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let cellView: UIView!
        if let view: UIView = cell.viewWithTag(111) {
            cellView = view
        } else {
            cellView = UIView(frame: CGRect(x: 10.0, y: 0, width: cell.frame.width - 20.0, height: 80.0))
            cellView.tag = 111
            cellView.accessibilityIdentifier = "CellViewID"
            cellView.backgroundColor = .clear
            cell.addSubview(cellView)
            let urlLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: 40.0))
            urlLabel.textColor = .black
            urlLabel.font = .systemFont(ofSize: 14.0)
            urlLabel.numberOfLines = 0
            cellView.addSubview(urlLabel)
            let resultLabel: UILabel = UILabel(frame: CGRect(x: (cellView.frame.width - 200) / 2.0, y: 40.0, width: 200, height: 25.0))
            resultLabel.textColor = .black
            resultLabel.accessibilityIdentifier = "ResultLabelID"
            resultLabel.textAlignment = .center
            resultLabel.font = .boldSystemFont(ofSize: 13.0)
            cellView.addSubview(resultLabel)
        }
        let urlLabel: UILabel = cellView.subviews[0] as! UILabel
        let resultLabel: UILabel = cellView.subviews[1] as! UILabel
        print(self.result.count)
        print(indexPath.row)
        if self.result.count > indexPath.row {
            if self.result[indexPath.row] {
                resultLabel.backgroundColor = .green
                resultLabel.text = "200 OK"
                resultLabel.isHidden = false
            } else {
                resultLabel.backgroundColor = .red
                resultLabel.text = "301 Moved Permanently"
                resultLabel.isHidden = false
            }
        } else {
            resultLabel.isHidden = true
        }
        urlLabel.text = self.urls[indexPath.row]
        return cell
    }
}


class ViewController: UIViewController  {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
    
        fileprivate static let MARGIN: CGFloat = 20.0
        
        static func SAFE_AREA() -> UIEdgeInsets {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets
        }
        
    }
    
    // MARK: - Declare Basic Variables
    
    private var urlList: UITableView!
    private var textView: UITextView!
    private var playBtn: UIButton!
    private var urls: [String] = ["http://www.mocky.io/v2/5e0af46b3300007e1120a7ef", "http://www.mocky.io/v2/5e0af421330000250020a7eb", "http://www.mocky.io/v2/5e0af415330000540020a7ea", "http://www.mocky.io/v2/5e0af3ff3300005f0020a7e7", "https://www.mocky.io/v2/5185415ba171ea3a00704eed"]
    private var result: [Bool] = []
    private var count: Int = 0
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Methods
    
    @objc private func endEditTextView() {
        self.textView.endEditing(true)
    }
    
    @objc private func addUrl() {
        self.playBtn.isEnabled = true
        self.textView.endEditing(true)
        self.urls.append(self.textView.text)
        self.textView.text = ""
        self.result = []
        self.urlList.reloadData()
    }
    
    @objc private func clear() {
        self.playBtn.isEnabled = false
        self.textView.endEditing(true)
        self.textView.text = ""
        self.urls = []
        self.result = []
        self.urlList.reloadData()
    }
    
    public func startLoad() {
        if self.count == self.urls.count {
            self.playBtn.isHidden = false
            self.activityIndicator.stopAnimating()
            return
        }
        self.count += 1
        let session = URLSession(configuration: .default)
        let url = URL(string: self.urls[self.count - 1])!
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let _ = error {
                    self.result.append(false)
                } else if let _ = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.result.append(true)
                }
                self.urlList.reloadData()
                self.startLoad()
            }
        }
        task.resume()
    }
    
    
    @objc private func play() {
        self.playBtn.isHidden = true
        self.activityIndicator.startAnimating()
        self.result = []
        self.count = 0
        self.urlList.reloadData()
        self.startLoad()
    }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgb: 0xf6f6f6)
        
        let topView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: DEFAULT.SAFE_AREA().top + 200.0))
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        
        let bottomBorderTopView = CALayer()
        bottomBorderTopView.frame = CGRect(x: 0, y: topView.frame.height - 1, width: topView.frame.width, height: 1.0)
        bottomBorderTopView.backgroundColor = UIColor(rgb: 0xe2e2e2).cgColor
        topView.layer.addSublayer(bottomBorderTopView)
        
        let title: UILabel = UILabel(frame: CGRect(x: DEFAULT.MARGIN, y: DEFAULT.SAFE_AREA().top + DEFAULT.MARGIN, width: topView.frame.width - DEFAULT.MARGIN * 2.0, height: 40.0))
        title.textColor = .black
        title.text = "Type a url:"
        title.font = .boldSystemFont(ofSize: 16.0)
        topView.addSubview(title)
        
        self.textView = UITextView(frame: CGRect(x: DEFAULT.MARGIN, y: title.frame.origin.y + title.frame.height, width: topView.frame.width - DEFAULT.MARGIN * 2.0, height: 60.0))
        self.textView.backgroundColor = UIColor(rgb: 0xf6f6f6)
        self.textView.textColor = .black
        self.textView.font = .systemFont(ofSize: 14.0)
        topView.addSubview(self.textView)
        
        
        let addUrlBtn: UIButton = UIButton(frame: CGRect(x: self.view.frame.width - 80.0 - DEFAULT.MARGIN, y: self.textView.frame.origin.y + self.textView.frame.height + DEFAULT.MARGIN / 2.0, width: 80.0, height: 40.0))
        addUrlBtn.addTarget(self, action: #selector(self.addUrl), for: .touchUpInside)
        addUrlBtn.setTitle("Add Url", for: .normal)
        addUrlBtn.setTitleColor(.black, for: .normal)
        addUrlBtn.backgroundColor = UIColor(rgb: 0xe2e2e2)
        topView.addSubview(addUrlBtn)
        
        let clearUrlBtn: UIButton = UIButton(frame: CGRect(x: DEFAULT.MARGIN, y: self.textView.frame.origin.y + self.textView.frame.height + DEFAULT.MARGIN / 2.0, width: 50.0, height: 40.0))
        clearUrlBtn.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        clearUrlBtn.setTitle("Clear", for: .normal)
        clearUrlBtn.setTitleColor(.black, for: .normal)
        topView.addSubview(clearUrlBtn)
        
        let bottomView: UIView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - DEFAULT.SAFE_AREA().bottom - 50.0, width: self.view.frame.width, height: DEFAULT.SAFE_AREA().bottom + 50.0))
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        
        let topBorderBottomView = CALayer()
        topBorderBottomView.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 1.0)
        topBorderBottomView.backgroundColor = UIColor(rgb: 0xe2e2e2).cgColor
        bottomView.layer.addSublayer(topBorderBottomView)
        
        let img_playIcon: UIImage! = UIImage(named: "PlayIcon")
        self.playBtn = UIButton(frame: CGRect(x: (bottomView.frame.width - img_playIcon.size.width) / 2.0, y: 10.0, width: img_playIcon.size.width, height: img_playIcon.size.height))
        self.playBtn.addTarget(self, action: #selector(self.play), for: .touchUpInside)
        self.playBtn.setImage(img_playIcon, for: UIControl.State.normal)
        self.playBtn.accessibilityIdentifier = "PlayBtnID"
        bottomView.addSubview(self.playBtn)
        
        
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.color = .black
        self.activityIndicator.center = CGPoint(x: bottomView.frame.width / 2.0, y: 30.0)
        bottomView.addSubview(self.activityIndicator)
        
        self.urlList = UITableView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.frame.width, height: self.view.frame.height - topView.frame.height - bottomView.frame.height ))
        self.urlList.accessibilityIdentifier = "UrlListID"
        self.urlList.backgroundColor = .clear
        self.urlList.dataSource = self as UITableViewDataSource
        self.urlList.delegate = self as UITableViewDelegate
        self.urlList.contentInsetAdjustmentBehavior = .never
        self.urlList.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseId")
        self.view.addSubview(self.urlList)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.endEditTextView))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: - Override Variables
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

}

