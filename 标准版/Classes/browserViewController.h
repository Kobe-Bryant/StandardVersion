//
//  browserViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "manageActionSheet.h"
#import "WeiboAccountViewController.h"

@class WBEngine;

@class manageActionSheet;
@interface browserViewController : UIViewController <UIWebViewDelegate,MBProgressHUDDelegate,commandOperationDelegate,LoginResultDelegate>{

	UIWebView *webView;
	MBProgressHUD *progressHUD;
	manageActionSheet *actionsheet;
	UIToolbar *testtb;
	NSString *linkurl;
	NSString *linktitle;
	UIBarButtonItem * ButtonItem;//  
	bool isHideToolbar;
	bool isFirstLoad;
	WBEngine *weiBoEngine;
	NSString *QQtokenKey;
	NSString *QQtokenSecret;
	NSString *sinaAccessToken;
	double sinaExpireTime;
    
    CGFloat viewHeight;
}
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UIToolbar *testtb;
@property(nonatomic,retain)NSString *linkurl;
@property(nonatomic,retain)NSString *linktitle;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic,retain)UIBarButtonItem *ButtonItem;
@property(nonatomic)bool isHideToolbar;
@property(nonatomic)bool isFirstLoad;
@property(nonatomic,retain)WBEngine *weiBoEngine;
@property(nonatomic,retain)NSString *QQtokenKey;
@property(nonatomic,retain)NSString *QQtokenSecret;
@property(nonatomic,retain)NSString *sinaAccessToken;
@property(nonatomic)double sinaExpireTime;
-(void)loadURL:(NSString*)str_URL;
-(IBAction)reload:(id)sender;
-(IBAction)search:(id)sender;
-(IBAction)share:(id)sender;
@end
