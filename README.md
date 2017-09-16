# UTUnsplash

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg?style=flat)
![License](https://img.shields.io/badge/platform-ios-11222f.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg?style=flat)

**UTUnsplash** cover image shower like iOS Gallery

<p align="center"><img src="https://github.com/mertyildiz41/UTUnsplash/blob/master/UTUnsplash.gif?raw=true"/></p>


### Customization
The following diagram provides a good overview:

### Requirements
- Requires iOS 7 or later. The sample project is optimized for iOS 8.
- Requires Automatic Reference Counting (ARC).

##### Apparence Properties
`mutableSelection` - Bool  
When is true every reflesh remove all selected images before call func from delegate. Defaults to 2.0.  

`navigationColor` - UIColor  
. Defaults to UIColor.clear.  

`navigationTitle` - String  
. Defaults to "UTUnsplash".

`navigationTitleColor` - UIColor  
. Defaults to UIColor.white.

`navigationLeftButtonText` - String  
. Defaults to "Cancel".

`navigationRightButtonText` - String  
. Defaults to "Done".

`SearchDefaultText` - String  
. Defaults to "Search".

`SearchTintColor` - UIColor  
. Defaults to UIColor.white.

`SearchBarStyle` - UIBarStyle  
. Defaults to UIBarStyle.default.

`navigationLeftButtonColor` - UIColor  
. Defaults to UIColor.blue.

`navigationRightButtonColor` - UIColor  
. Defaults to UIColor.blue.

`maximumNumberOfSelection` - Int  
. Defaults to 1.

`lineCount` - CGFloat  
. Defaults to 3.

`InteritemWidth` - CGFloat  
. Defaults to 1.

`imageContentMode` - UIViewContentMode  
. Defaults to .scaleAspectFill.

`lineSpacing` - CGFloat  
. Defaults to 1.

`maxPageLength` - Int  
. Defaults to 50.

`widthRatioToHeight` - CGFloat  
. Defaults to 1.5.

`refreshControl` - UIRefreshControl  
...

`customNameText` - [String:Any]?  
. Defaults to nil.

`UserImageType` - UTUnsplashUserImageType  
. Defaults to .small.


### Delegate 

```func UTUnsplashPickerDidCancel(_ UTUnsplashContoller:UTUnsplash) {
     //When UTUnsplash click to cancel button
}

func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,dismiss selects:[UTUnsplashObject]){
     //After choose images return list of images if make multiselect false list return only 1 element
}

optional function
func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,whenClearSelect selects:[UTUnsplashObject])```

optional function 
func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,didSelectImage image:UTUnsplashObject){
     //When any select item working this function 
}

optional function
func UTUnsplashPicker(_ UTUnsplashContoller:UTUnsplash,didUnSelectImage image:UTUnsplashObject){
    //When any items make unselect working this function`
}```


### Contact ME
For question or wanna contact with me send mail : mertyildiz.295107@hotmail.com
