//
//  WeiboAccountViewController.h
//  du
//
//  Created by MC374 on 12-4-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppStromAppDelegate.h"

@class WBEngine;
@class OpenSdkOauth;
@class OpenApi;
@class MBProgressHUD;

@protocol LoginResultDelegate <NSObject>
-(void)loginSuccess:(NSString*)withLoginType;
@end

@interface WeiboAccountViewController : UIViewController<SinaWeiboDelegate,APPlicationDelegate,SinaWeiboRequestDelegate> {
	UITableView *myTableView;
	NSMutableArray *weiboArray;
	BOOL isSinaBinding;
	BOOL isTencentBinding;
	NSString *sinaName;
	NSString *tencentName;
	WBEngine *weiBoEngine;
	NSString *QQtokenKey;
	NSString *QQtokenSecret;
	NSString *sinaAccessToken;
	double sinaExpireTime;
	UIButton *sinaBut;
	UIButton *tencentBut;
	id<LoginResultDelegate> delegate;
	
	IBOutlet UIWebView *_webView;
    UILabel *_titleLabel;    
    OpenSdkOauth *_OpenSdkOauth;
	OpenApi *_OpenApi;
    SinaWeibo *sinaWeibo;
    MBProgressHUD *progressHUD;
    BOOL hasOauth;
}
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *weiboArray;
@property(nonatomic,retain) NSString *sinaName;
@property(nonatomic,retain) NSString *tencentName;
@property(nonatomic) BOOL isSinaBinding;
@property(nonatomic) BOOL isTencentBinding;
@property(nonatomic,retain)WBEngine *weiBoEngine;
@property(nonatomic,retain)NSString *QQtokenKey;
@property(nonatomic,retain)NSString *QQtokenSecret;
@property(nonatomic,retain)NSString *sinaAccessToken;
@property(nonatomic,retain)UIButton *sinaBut;
@property(nonatomic,retain)UIButton *tencentBut;
@property(nonatomic)double sinaExpireTime;
@property(nonatomic,assign)id<LoginResultDelegate> delegate;
-(void) handleButtonPress:(id)sender;
-(void) updateView;
@end
