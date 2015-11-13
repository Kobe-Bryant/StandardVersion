//
//  OriginWallPaperViewController.h
//  szeca
//
//  Created by MC374 on 12-3-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBEngine;

#import <UIKit/UIKit.h>
#import "myZoomImageView.h"
#import "manageActionSheet.h"
#import "myImageView.h"
#import "IconDownLoader.h"
#import "WeiboAccountViewController.h"
#define SHOW_PRODUCT_PIC 1
#define SHOW_WALLPAPER 2
@interface OriginWallPaperViewController : UIViewController <commandOperationDelegate,UIScrollViewDelegate,IconDownloaderDelegate,myImageViewDelegate,myZoomImageViewDelegate,LoginResultDelegate>{
	
	UIImage *originPic;
	NSString *picName;
	myZoomImageView *dragger;
	NSMutableArray *picArray;
	int imageviewTag;
	int imageviewTagtmp;
	UIToolbar *tbar;
	UIToolbar *toolBar;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	UIPageControl *pageControl;
	UIScrollView *scrollview;
	int chooseIndex;
	int showWhichOriginPic;
	NSNumber *productId;
	NSArray *ar_product;
	manageActionSheet *actionsheet;
	NSMutableDictionary *indexToPicDic;
	NSString *titleString;
	WBEngine *weiBoEngine;
	NSString *QQtokenKey;
	NSString *QQtokenSecret;
	NSString *sinaAccessToken;
	double sinaExpireTime;
    
    UIView *toolBarView;
}
@property(nonatomic,assign)NSNumber *productId;
@property(nonatomic,retain)NSMutableDictionary *indexToPicDic;
@property(nonatomic,retain)NSArray *ar_product;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UIScrollView *scrollview;
@property(nonatomic,retain)NSString *picName;
@property(nonatomic,retain)UIImage *originPic;
@property(nonatomic,retain)myZoomImageView *dragger;
@property(nonatomic,retain)NSMutableArray *picArray;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain)NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain)NSMutableArray *imageDownloadsInWaiting;
@property (nonatomic,assign)int chooseIndex;
@property(nonatomic,assign)int showWhichOriginPic;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic,retain)NSString *titleString;
@property(nonatomic,retain)WBEngine *weiBoEngine;
@property(nonatomic,retain)NSString *QQtokenKey;
@property(nonatomic,retain)NSString *QQtokenSecret;
@property(nonatomic,retain)NSString *sinaAccessToken;
@property(nonatomic)double sinaExpireTime;
//-(IBAction)turnBack:(id)sender;
-(IBAction)HandleToBrowser:(id)sender;
-(IBAction)HandleLoadDown:(id)sender;
-(IBAction)HandleShare:(id)sender;
@end
