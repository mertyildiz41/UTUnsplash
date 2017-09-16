//
//  UTUnsplash.swift
//  UTUnsplash
//
//  Created by Edward MORGAN on 9/7/17.
//  Copyright © 2017 Mert YILDIZ. All rights reserved.
//
enum UTUnsplashUserImageType {
    case small
    case large
    case medium
    var Value: String {
        switch self {
            case .medium: return "medium"
            case .large: return "large"
            case .small: return "small"
        }
    }
}
struct UTUnsplashUser {
    var Id:String?
    var Username:String?
    var Name:String?
    var Surname:String?
    var ProfilImageUrl:String?
    var Bio:String?
    var Total_likes:Int?
    var Total_photos:Int?
    var Total_collections:Int?
    var Location:String?
}

class UTUnsplashObject:NSObject {
    var Id:String?
    var ThumbUrl:String?
    var RegularUrl:String?
    var FullUrl:String?
    var Date:String?
    var Width:Int?
    var Height:Int?
    var Color:String?
    var Likes:Int?
    var Description:String?
    var User:UTUnsplashUser?
    var ThumbImage:UIImage?
    
    override init() {
        
    }
    init(_thumbUrl:String?,_regularUrl:String?,_fullUrl:String?,_date:String?,_width:Int?,_height:Int?,_color:String?,_likes:Int?,_description:String?,_id:String?,_user:UTUnsplashUser) {
        self.ThumbUrl = _thumbUrl
        self.Id = _id
        self.RegularUrl = _regularUrl
        self.FullUrl = _fullUrl
        self.Date = _date
        self.Width = _width
        self.Height = _height
        self.Color = _color
        self.Likes = _likes
        self.Description = _description
        self.User = _user
    }
}

import Foundation
import UIKit

open class UTUnsplash:UIViewController {
    
    var mutableSelection = false
    var navigationColor = UIColor.clear
    var navigationTitle = "UTUnsplash"
    var navigationTitleColor = UIColor.white
    var navigationLeftButtonText = "Cancel"
    var navigationRightButtonText = "Done"
    var SearchDefaultText = "Search"
    var SearchTintColor = UIColor.white
    var SearchBarStyle = UIBarStyle.default
    var navigationLeftButtonColor = UIColor.blue
    var navigationRightButtonColor = UIColor.blue
    var maximumNumberOfSelection: Int = 1
    var lineCount:CGFloat = 3
    var InteritemWidth:CGFloat = 1
    var imageContentMode = UIViewContentMode.scaleAspectFill
    var lineSpacing:CGFloat = 1
    var cellRadius:CGFloat = 0
    var maxPageLength = 50
    var widthRatioToHeight:CGFloat = 1.5
    var refreshControl = UIRefreshControl()
    var customNameText:[String:Any]? = nil
    var UserImageType = UTUnsplashUserImageType.small
    var delegate: UTUnsplashControllerDelegate?
    var apiKey = ""//Your Application Key
    
    lazy var assetBundle:Bundle = {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "UTUnsplash", ofType: "bundle") {
            return Bundle(path: path)!
        }
        return bundle
    }()
    lazy var storyboardBundle:Bundle = {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "UTUnsplashStoryboard", ofType: "storyboard") {
            return Bundle(path: path)!
        }
        return bundle
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // show albumListViewController
        let storyboard = UIStoryboard(name: "UTUnsplashStoryboard", bundle: assetBundle)
        let viewControllerId = "UTUnsplashNavigation"
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? UINavigationController else {
            fatalError("navigationController init failed.")
        }
        addChildViewController(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: self)
        
        guard let _UTUnsplashController = navigationController.topViewController as? UTUnsplashViewController else {
            fatalError("albumListViewController is not topViewController.")
        }
        _UTUnsplashController.Unsplash = self
    }
}

@objc protocol UTUnsplashControllerDelegate {
    func UTUnsplashPickerDidCancel(_ UTUnsplashContoller:UTUnsplash)
    func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,dismiss selects:[UTUnsplashObject])
    @objc optional func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,whenClearSelect selects:[UTUnsplashObject])
    @objc optional func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,didSelectImage image:UTUnsplashObject)
    @objc optional func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,didUnSelectImage image:UTUnsplashObject)
}

extension String {
    func ToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



