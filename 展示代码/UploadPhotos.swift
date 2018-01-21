//
//这段代码是我个人project petselector里的一段用于上传pet照片和一些信息的代码。
//这段代码里我用到了DispatchQueue.global()全局队列。异步开启线程进行耗时的上传图片和信息到server的任务。并且使用了一些第三方库。
//上传这段代码的原因： ios开发是自学，从这段代码开始，我的ios开发上了一个台阶。一开始编写的时候会遇到上传结束时无法与app交互的问题。后来经过几番查找原因，才知道ios里的main函数主更新ui相关，耗时的操作应该用其他的线程完成。我的代码还存在缺陷，比如没有使用mvc设计模式等，当时太naive，完全没有考虑到，倒是后来的更新与维护不容易做。现在已经认识到了这个问题。


//
//  UploadPhotos.swift
//  PetSelector
//
//  Created by 刘月 on 7/21/17.
//  Copyright © 2017 YueLiu. All rights reserved.
//

import UIKit
import Parse

extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.2
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    } 
}

class UploadPhotos: UIViewController, HXPhotoViewDelegate, HXPhotoViewControllerDelegate, LocationSelectorDelegate , BreedSelectorDelegate {
   
   
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var breedLbl: UILabel!
    //var uimanager = HXPhotoUIManager()
    
    var petPhotos = [UIImage]()
    var photocount: Int?
    var scrollView: UIScrollView?

    var morePhotoView: HXPhotoView?

    private var _morePhotoManage: HXPhotoManager?
    var morePhotoManager: HXPhotoManager? {
        if _morePhotoManage == nil {
            
            _morePhotoManage = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
            _morePhotoManage?.openCamera = true
            _morePhotoManage?.cameraType = HXPhotoManagerCameraTypeSystem
            
            _morePhotoManage?.photoMaxNum = 9
            _morePhotoManage?.maxNum = 9
            _morePhotoManage?.rowCount = 4
            //_morePhotoManage?.uiManager = uimanager
            
           // uimanager.hideOriginalBtn = true
            
        }
        return _morePhotoManage
     }
    
    private var _avaManage: HXPhotoManager?
    var avaManager: HXPhotoManager? {
        if _avaManage == nil {
            _avaManage = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
            _avaManage?.openCamera = true
            _avaManage?.singleSelected = true
            _avaManage?.cameraType = HXPhotoManagerCameraTypeFullScreen
        }
        return _avaManage
    }
    
    var alertView: UIVisualEffectView!
     
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "填写资料"
        
        //new back button
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
       
        
        avaImage.layer.cornerRadius = avaImage.frame.size.width / 2
        avaImage.clipsToBounds = true
        
        // tap to choose location
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(selectLocation))
        //locationLbl.numberOfTapsRequired = 1
        locationLbl.isUserInteractionEnabled = true
        locationLbl.addGestureRecognizer(locationTap)
        
        
        // tap to choose breed
        let breedTap = UITapGestureRecognizer(target: self, action: #selector(selectBreed))
        breedLbl.isUserInteractionEnabled = true
        breedLbl.addGestureRecognizer(breedTap)
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadAvaImage))
        avaImage.isUserInteractionEnabled = true
        avaImage.addGestureRecognizer(avaTap)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        view.addSubview(scrollView!)
        scrollView?.addSubview(upperView)
        
        morePhotoView = HXPhotoView(frame: CGRect(x: 20, y: (upperView?.frame.height)!, width: view.frame.size.width - 40, height: 0), with: morePhotoManager)
        morePhotoView?.delegate = self
        scrollView?.addSubview(morePhotoView!)
        
        navigationController?.navigationBar.isTranslucent = false
        //automaticallyAdjustsScrollViewInsets = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(self.publish))

        
     
    }
    //load 宠物的头像
    func loadAvaImage() {
        let vc = HXPhotoViewController()
        vc.manager = avaManager
        vc.delegate = self
        present(UINavigationController(rootViewController: vc as UIViewController), animated: false) { _ in }
    }
    
    //DELEGATE
    func photoViewUpdateFrame(_ frame: CGRect, with photoView: HXPhotoView) {
         if morePhotoView == photoView {
         morePhotoView?.frame = CGRect(x: 0, y: (upperView?.frame.height)!, width: view.frame.size.width, height: (morePhotoView?.frame.size.height)!)
         
         }
         
         scrollView?.contentSize = CGSize(width: view.frame.size.width, height: (upperView.frame.size.height + (morePhotoView?.frame.height)!) + 100)
        
    }
    
    func photoViewDeleteNetworkPhoto(_ networkPhotoUrl: String) {
        print("\(networkPhotoUrl)")
    }
    

    //点击选择宠物详情页照片
    func didNavBtnClick() {
        morePhotoView?.goController()
    }
    
    func photoView(_ photoView: HXPhotoView!, changeComplete allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        photocount = photos.count

        var fetchType: HXPhotoToolsFetchType!
        if isOriginal {
           fetchType = HXPhotoToolsFetchOriginalImageTpe
        } else {
            fetchType = HXPhotoToolsFetchHDImageType
        }
        
        HXPhotoTools.getImageForSelectedPhoto(photos, type: fetchType) { (images:[UIImage]?) in
            self.petPhotos.removeAll(keepingCapacity: false)
            
            for image in images! {
                self.petPhotos.append(image)
            }

        }
        
    }


    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        let model: HXPhotoModel? = allList.first
        avaImage.image = model?.thumbPhoto
    }
    
    func photoViewControllerDidCancel() {}
    
    
    func selectLocation() {
        let locationSelector = LocationSelector("upload")
        locationSelector.delegate = self;
        self.navigationController?.pushViewController(locationSelector, animated: true)
    }
    
    
    func selectBreed() {
        let breedSelector = BreedSelector(false)
        breedSelector.delegate = self;
        self.navigationController?.pushViewController(breedSelector, animated: true)
        
    }
    
    
    func locationSelected(_ locations: String) {
        locationLbl.text = locations
        locationLbl.textColor = .black
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
    func breedSelected(_ breeds: [String]) {
        var selectedBreeds = String()
        for breed in breeds {
            selectedBreeds += breed + "\n"
        }
        breedLbl.text = selectedBreeds.trimmingCharacters(in: NSCharacterSet.newlines)
        breedLbl.textColor = .black
        self.navigationController?.popToViewController(self, animated: true)
    }
    

    //保存信息到server
    func publish() {
       
        if locationLbl.text! == "点我选择..." {JJHUD.showText(text: "请选择地区", delay: 1.25, enable: false)}
        else if breedLbl.text! == "点我选择..." {JJHUD.showText(text: "请选择品种", delay: 1.25, enable: false)}
        else if avaImage.image == #imageLiteral(resourceName: "petAva") {JJHUD.showText(text: "请选择宠物头像", delay: 1.25, enable: false)}
        else if photocount == 0 || photocount == nil {JJHUD.showText(text: "请选择详情页照片", delay: 1.25, enable: false)}
                
        else if locationLbl.text! != "点我选择..." && breedLbl.text! != "点我选择..." && avaImage.image != #imageLiteral(resourceName: "petAva") &&  petPhotos.count == photocount {
            
            // send notification
            NotificationCenter.default.post(name: Notification.Name(rawValue: "beginActivityIndicator"), object: nil)
        
            DispatchQueue.global().async {
                
                var petPhotoObject = [PFObject]()

                for photo in self.petPhotos {
                    
                    //save pet photos into server
                    let photoobject = PFObject(className: "petphotos")
                    photoobject["petphoto"] = PFFile(name: "\(PFUser.current()!.objectId!)petphotos.jpg", data: photo.compressTo(2)!)
                    petPhotoObject.append(photoobject)
                    
                }

                PFObject.saveAll(inBackground: petPhotoObject, block: { (success, error) in
                    if success {
                        var petPhotoID = [String]()
                        for object in petPhotoObject {
                            petPhotoID.append(object.objectId!)
                        }
                        
                        //save post to server
                        let postobject = PFObject(className: "Post")
                        postobject["location"] = self.locationLbl.text!.trimmingCharacters(in: .whitespaces)
                        postobject["breed"] = self.breedLbl.text!.replacingOccurrences(of: " ", with: "")
                        postobject["owner"] = PFUser.current()!.objectId
                        postobject["petname"] = petnameUpload
                        postobject["gender"] = genderUpload
                        postobject["age"] = ageUpload
                        postobject["size"] = sizeUpload
                        postobject["color"] = colorUpload
                        postobject["petphotos"] = petPhotoID
                        postobject["shot"] = shotUpload
                        postobject["neuter"] = neuterUpload
                        postobject["deworm"] = dewormUpload
                        postobject["adopted"] = false
                        postobject["story"] = storyUpload
                        postobject["like"] = likeUpload
                        postobject["contact"] = contactUpload
                        
                        // send ava picture to server
                        let avaFile = PFFile(name: "petava.jpg", data: self.avaImage.image!.compressTo(2)!)
                        postobject["petava"] = avaFile
                        postobject.saveInBackground (block: { (success, error) -> Void in
                            if error == nil {
                                // send notification 发布成功
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadSuccess"), object: nil)
                           
                            } else {
                                // send notification 发布失败
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadFail"), object: nil)
                            }
                            
                        })
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopActivityIndicator"), object: nil)
                    
                    } else {
                         NotificationCenter.default.post(name: Notification.Name(rawValue: "stopActivityIndicator"), object: nil)
            
                        // send notification 发布失败
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadFail"), object: nil)

                    }
                    
                })
            
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            JJHUD.showText(text: "正在处理图片，请稍等", delay: 1, enable: true)
        }
      
    }
    
    func back(){
    
        self.navigationController?.popViewController(animated: true)

    }
    
    
}

