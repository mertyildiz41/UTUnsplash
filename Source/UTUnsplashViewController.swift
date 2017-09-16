//
//  UTUnsplashViewController.swift
//  UTUnsplash
//
//  Created by Edward MORGAN on 9/7/17.
//  Copyright © 2017 Mert YILDIZ. All rights reserved.
//

import UIKit

class UTUnsplashViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {


    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var Unsplash:UTUnsplash? = nil
    private var selectList:[Int] = []
    private var UnsplashList:[UTUnsplashObject] = []
    private var page = 1
    private var isSearch = false
    private var LoadingView = UTUnsplashLoadingOverlay()
    private var lastIndex = 0
    private var lastquery = ""
    private var waitingReload = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = Unsplash?.navigationTitle
        
        self.searchBar.barTintColor = Unsplash?.SearchTintColor
        self.searchBar.placeholder = Unsplash?.SearchDefaultText
        self.searchBar.barStyle = (Unsplash?.SearchBarStyle)!

        self.navigationController?.navigationBar.backgroundColor = Unsplash?.navigationColor
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = Unsplash?.navigationTitleColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName :  Unsplash?.navigationTitleColor ?? UIColor.white]
        
        self.navigationBar.rightBarButtonItem?.tintColor = Unsplash?.navigationRightButtonColor
        self.navigationBar.leftBarButtonItem?.tintColor = Unsplash?.navigationLeftButtonColor
        self.navigationBar.rightBarButtonItem?.title = Unsplash?.navigationRightButtonText
        self.navigationBar.leftBarButtonItem?.title = Unsplash?.navigationLeftButtonText
        
        Unsplash?.refreshControl.addTarget(self, action: #selector(refleshData), for: UIControlEvents.valueChanged)
        collectionView.addSubview((Unsplash?.refreshControl)!)
        
        LoadingView.showOverlay(view: self.view)
        UTUnsplashService().getPhotoes(applicationKey:(self.Unsplash?.apiKey)! ,page: page, completion: {
            (success,object) in
            if success && object != nil {
                self.UnsplashList = []
                for item in object! {
                    let _url = (item as AnyObject).value(forKey:"urls")as? NSDictionary
                    let _user = (item as AnyObject).value(forKey:"user")as? NSDictionary
                    self.UnsplashList.append(UTUnsplashObject(_thumbUrl: _url?.value(forKey: "thumb")as? String, _regularUrl: _url?.value(forKey: "regular")as? String, _fullUrl: _url?.value(forKey: "full")as? String, _date: (item as AnyObject).value(forKey:"created_at")as? String, _width: (item as AnyObject).value(forKey:"width")as? Int, _height: (item as AnyObject).value(forKey:"height")as? Int, _color: (item as AnyObject).value(forKey:"color")as? String, _likes: (item as AnyObject).value(forKey:"likes")as? Int, _description: (item as AnyObject).value(forKey:"description")as? String, _id: (item as AnyObject).value(forKey:"id")as? String, _user: UTUnsplashUser(Id: _user?.value(forKey: "id")as? String, Username: _user?.value(forKey: "username")as? String, Name: _user?.value(forKey: "first_name")as? String, Surname: _user?.value(forKey: "last_name")as? String, ProfilImageUrl: (_user?.value(forKey: "profile_image")as? NSDictionary)?.value(forKey: (self.Unsplash?.UserImageType.Value)!)as? String, Bio: _user?.value(forKey: "bio")as? String, Total_likes: _user?.value(forKey: "total_likes")as? Int, Total_photos: _user?.value(forKey: "total_photoes")as? Int, Total_collections: _user?.value(forKey: "total_collections")as? Int,Location:_user?.value(forKey: "location")as? String)))
                }
                self.lastIndex = self.UnsplashList.count - 1
                DispatchQueue.main.async { () -> Void in
                    self.LoadingView.hideOverlayView()
                    self.collectionView.reloadData()
                }
            }
            else{
                DispatchQueue.main.async { () -> Void in
                    self.LoadingView.hideOverlayView()
                    //Error can't connect to api :/ somethings wrong
                    UIAlertView(title: "Hata", message: "Bir hata ile karşılaşıldı.İnternet bağlantınızın olduğundan emin olunuz.", delegate: nil, cancelButtonTitle: "Tamam").show()
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func refleshData() {
        LoadingView.showOverlay(view: self.view)
        self.page = 1
        
        ReloadMorePicture()
    }
    
    func ReloadMorePicture(){
        if self.page <= (self.Unsplash?.maxPageLength)! {
            self.waitingReload = true
            if self.lastquery == "" {
                UTUnsplashService().getPhotoes(applicationKey:(self.Unsplash?.apiKey)!,page: page, completion: {
                    (success,object) in
                    if success && object != nil {
                        if self.page == 1 {
                            var lastSelected:[UTUnsplashObject] = []
                            for i in self.selectList {
                                lastSelected.append(self.UnsplashList[i])
                            }
                            if self.Unsplash?.delegate != nil {
                                self.Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, whenClearSelect: lastSelected)
                            }
                            self.selectList = []
                            self.UnsplashList = []
                        }
                        for item in object! {
                            let _url = (item as AnyObject).value(forKey:"urls")as? NSDictionary
                            let _user = (item as AnyObject).value(forKey:"user")as? NSDictionary
                            self.UnsplashList.append(UTUnsplashObject(_thumbUrl: _url?.value(forKey: "thumb")as? String, _regularUrl: _url?.value(forKey: "regular")as? String, _fullUrl: _url?.value(forKey: "full")as? String, _date: (item as AnyObject).value(forKey:"created_at")as? String, _width: (item as AnyObject).value(forKey:"width")as? Int, _height: (item as AnyObject).value(forKey:"height")as? Int, _color: (item as AnyObject).value(forKey:"color")as? String, _likes: (item as AnyObject).value(forKey:"likes")as? Int, _description: (item as AnyObject).value(forKey:"description")as? String, _id: (item as AnyObject).value(forKey:"id")as? String, _user: UTUnsplashUser(Id: _user?.value(forKey: "id")as? String, Username: _user?.value(forKey: "username")as? String, Name: _user?.value(forKey: "first_name")as? String, Surname: _user?.value(forKey: "last_name")as? String, ProfilImageUrl: (_user?.value(forKey: "profile_image")as? NSDictionary)?.value(forKey: (self.Unsplash?.UserImageType.Value)!)as? String, Bio: _user?.value(forKey: "bio")as? String, Total_likes: _user?.value(forKey: "total_likes")as? Int, Total_photos: _user?.value(forKey: "total_photoes")as? Int, Total_collections: _user?.value(forKey: "total_collections")as? Int,Location:_user?.value(forKey: "location")as? String)))
                        }
                        self.lastIndex = self.UnsplashList.count - 1
                        DispatchQueue.main.async { () -> Void in
                            self.Unsplash?.refreshControl.endRefreshing()
                            self.LoadingView.hideOverlayView()
                            self.collectionView.reloadData()
                            if self.page == 1 {
                                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                            }
                            self.waitingReload = false
                        }
                    }
                    else{
                        DispatchQueue.main.async { () -> Void in
                            self.Unsplash?.refreshControl.endRefreshing()
                            self.waitingReload = false
                            self.LoadingView.hideOverlayView()
                            if self.page != 1 {
                                self.page -= 1
                            }
                            //Error can't connect to api :/ somethings wrong
                            UIAlertView(title: "Hata", message: "Bir hata ile karşılaşıldı.İnternet bağlantınızın olduğundan emin olunuz.", delegate: nil, cancelButtonTitle: "Tamam").show()
                        }
                    }
                })
            }
            else{
                UTUnsplashService().getQueryPhotoes(applicationKey:(self.Unsplash?.apiKey)!,page: self.page, query: self.lastquery, completion: {
                    (success,object) in
                    if success && object != nil {
                        if self.page == 1 {
                            var lastSelected:[UTUnsplashObject] = []
                            for i in self.selectList {
                                lastSelected.append(self.UnsplashList[i])
                            }
                            if self.Unsplash?.delegate != nil {
                                self.Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, whenClearSelect: lastSelected)
                            }
                            self.selectList = []
                            self.UnsplashList = []
                        }
                        for item in object! {
                            let _url = (item as AnyObject).value(forKey:"urls")as? NSDictionary
                            let _user = (item as AnyObject).value(forKey:"user")as? NSDictionary
                            self.UnsplashList.append(UTUnsplashObject(_thumbUrl: _url?.value(forKey: "thumb")as? String, _regularUrl: _url?.value(forKey: "regular")as? String, _fullUrl: _url?.value(forKey: "full")as? String, _date: (item as AnyObject).value(forKey:"created_at")as? String, _width: (item as AnyObject).value(forKey:"width")as? Int, _height: (item as AnyObject).value(forKey:"height")as? Int, _color: (item as AnyObject).value(forKey:"color")as? String, _likes: (item as AnyObject).value(forKey:"likes")as? Int, _description: (item as AnyObject).value(forKey:"description")as? String, _id: (item as AnyObject).value(forKey:"id")as? String, _user: UTUnsplashUser(Id: _user?.value(forKey: "id")as? String, Username: _user?.value(forKey: "username")as? String, Name: _user?.value(forKey: "first_name")as? String, Surname: _user?.value(forKey: "last_name")as? String, ProfilImageUrl: (_user?.value(forKey: "profile_image")as? NSDictionary)?.value(forKey: (self.Unsplash?.UserImageType.Value)!)as? String, Bio: _user?.value(forKey: "bio")as? String, Total_likes: _user?.value(forKey: "total_likes")as? Int, Total_photos: _user?.value(forKey: "total_photoes")as? Int, Total_collections: _user?.value(forKey: "total_collections")as? Int,Location:_user?.value(forKey: "location")as? String)))
                        }
                        self.lastIndex = self.UnsplashList.count - 1
                        DispatchQueue.main.async { () -> Void in
                            self.Unsplash?.refreshControl.endRefreshing()
                            self.LoadingView.hideOverlayView()
                            self.collectionView.reloadData()
                            if self.page == 1 {
                                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                            }
                            self.waitingReload = false
                        }
                    }
                    else{
                        DispatchQueue.main.async { () -> Void in
                            self.Unsplash?.refreshControl.endRefreshing()
                            self.waitingReload = false
                            self.LoadingView.hideOverlayView()
                            if self.page != 1 {
                                self.page -= 1
                            }
                            //Error can't connect to api :/ somethings wrong
                            UIAlertView(title: "Hata", message: "Bir hata ile karşılaşıldı.İnternet bağlantınızın olduğundan emin olunuz.", delegate: nil, cancelButtonTitle: "Tamam").show()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Controller Actions
    @IBAction func clickCancelButton(_ sender: Any) {
        if Unsplash?.delegate != nil {
            Unsplash?.delegate?.UTUnsplashPickerDidCancel(Unsplash!)
        }
    }
    
    @IBAction func clickDoneButton(_ sender: Any) {
        if Unsplash?.delegate != nil {
            var lastSelected:[UTUnsplashObject] = []
            for i in self.selectList {
                lastSelected.append(self.UnsplashList[i])
            }
            Unsplash?.delegate?.UTUnsplashPicker(Unsplash!, dismiss: lastSelected)
        }
    }
    
    // MARK: - SearchBar Delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if self.lastquery != searchBar.text {
            LoadingView.showOverlay(view: self.view)
            self.page = 1
            self.lastquery = searchBar.text!
            ReloadMorePicture()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if self.lastquery != searchBar.text {
            LoadingView.showOverlay(view: self.view)
            self.page = 1
            self.lastquery = searchBar.text!
            ReloadMorePicture()
        }
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UnsplashList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as? UTUnsplashCell
        cell?.Image.image = UIImage()
        cell?.Image.backgroundColor = UnsplashList[indexPath.row].Color?.ToUIColor()
        if UnsplashList[indexPath.row].ThumbImage == nil {
            if let url = URL(string: (self.UnsplashList[indexPath.row].ThumbUrl ?? "")) {
                getDataFromUrl(url: url ,completion : { (data, response, error) in
                    if data != nil {
                        DispatchQueue.main.async { () -> Void in
                            let cl = collectionView.cellForItem(at: indexPath)as? UTUnsplashCell
                            self.UnsplashList[indexPath.row].ThumbImage = UIImage(data: data!)
                            cl?.Image.image = self.UnsplashList[indexPath.row].ThumbImage
                        }
                    }
                })
            }
        }
        else{
            cell?.Image.image = UnsplashList[indexPath.row].ThumbImage
        }
        cell?.Image.contentMode = Unsplash?.imageContentMode ?? UIViewContentMode.scaleAspectFill
        cell?.contentView.clipsToBounds = true
        cell?.contentView.layer.cornerRadius = (self.Unsplash?.cellRadius)!
        let _name = (self.UnsplashList[indexPath.row].User?.Name ?? "") + " " + (self.UnsplashList[indexPath.row].User?.Surname ?? "")
        cell?.fromSendText.attributedText = NSAttributedString(string: _name, attributes: self.Unsplash?.customNameText)
        cell?.clickImage.image = self.selectList.index(where: {$0 == indexPath.row}) == nil ? UIImage(named: "btn_select") : UIImage(named: "btn_selected")
        if indexPath.row == self.lastIndex && self.waitingReload == false {
            self.page += 1
            self.ReloadMorePicture()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (Unsplash?.mutableSelection)! {
            if let index = selectList.index(where: { $0 == indexPath.row}) {
                selectList.remove(at: index)
                if Unsplash?.delegate != nil {
                    Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, didUnSelectImage: UnsplashList[indexPath.row])
                }
            }
            else{
                if (Unsplash?.maximumNumberOfSelection)! >= selectList.count {
                    selectList.append(indexPath.row)
                    if Unsplash?.delegate != nil {
                        Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, didSelectImage: UnsplashList[indexPath.row])
                    }
                }
            }
        }
        else{ //dismiss controller
            if selectList.count == 0 {
                selectList.append(indexPath.row)
                if Unsplash?.delegate != nil {
                    Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, didSelectImage: UnsplashList[indexPath.row])
                }
            }
            else if let index = selectList.index(where: { $0 == indexPath.row}) {
                selectList.remove(at: index)
                if Unsplash?.delegate != nil {
                    
                    Unsplash?.delegate?.UTUnsplashPicker?(self.Unsplash!, didUnSelectImage: UnsplashList[indexPath.row])
                }
            }
        }
        let cell = collectionView.cellForItem(at: indexPath)as? UTUnsplashCell
        cell?.clickImage.image = self.selectList.index(where: {$0 == indexPath.row}) == nil ? UIImage(named: "btn_select") : UIImage(named: "btn_selected")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake((Unsplash?.lineSpacing)!, (Unsplash?.InteritemWidth)!, (Unsplash?.lineSpacing)!, (Unsplash?.InteritemWidth)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (Unsplash?.lineSpacing)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (Unsplash?.lineSpacing)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / (Unsplash?.lineCount)!) - ((((Unsplash?.lineCount)! + 1) / 2) * (Unsplash?.lineSpacing)!) ) , height: ((collectionView.frame.width / (Unsplash?.lineCount)!) - ((((Unsplash?.lineCount)! + 1) / 2) * (Unsplash?.lineSpacing)!)) * (Unsplash?.widthRatioToHeight)!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
