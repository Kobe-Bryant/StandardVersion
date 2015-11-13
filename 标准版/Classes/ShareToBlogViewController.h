//
//  ShareToBlogViewController.h
//  du
//
//  Created by MC374 on 12-4-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

#import "WBEngine.h"
#import "MBProgressHUD.h"
#import "OpenApi.h"

@interface ShareToBlogViewController : UIViewController <UITextViewDelegate,SinaWeiboRequestDelegate,MBProgressHUDDelegate,WBEngineDelegate,OpenAPiDelegate>{
    UIImageView *backImageView;
	UIImageView *textViewBackImageView;
	UITextView *myTextView;
	UIButton *imageButton;
	UIButton *selectButton;
	UILabel *sendLabel;
	UIButton *sendButton;
	BOOL checkBoxSelected;
	NSString *defaultContent;
	UIImage *shareImage;
	NSString *sinaAccessToken;
	WBEngine *engine;
	NSString *qAccessToken;
	NSString *qOpenid;
	NSString *qWeiboUserName;
	int weiBoType;
	NSURLConnection *connection;
	MBProgressHUD *progressHUD;
	BOOL isStillSending;
    SinaWeibo *sinaWeibo;
}
@property(nonatomic,retain) IBOutlet UIImageView *backImageView;
@property(nonatomic,retain) IBOutlet UIImageView *textViewBackImageView;
@property(nonatomic,retain) IBOutlet UITextView *myTextView;
@property(nonatomic,retain) IBOutlet UIButton *imageButton;
@property(nonatomic,retain) IBOutlet UIButton *selectButton;
@property(nonatomic,retain) IBOutlet UILabel *sendLabel;
@property(nonatomic,retain) IBOutlet UIButton *sendButton;
@property(nonatomic,retain) NSString *defaultContent;
@property(nonatomic,retain) UIImage *shareImage;
@property(nonatomic,retain) NSString *sinaAccessToken;
@property(nonatomic,retain) WBEngine *engine;
@property(nonatomic,retain) NSString *qAccessToken;
@property(nonatomic,retain) NSString *qOpenid;
@property(nonatomic,retain) NSString *qWeiboUserName;
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic) BOOL checkBoxSelected;
@property(nonatomic) int weiBoType;
@property(nonatomic) BOOL isStillSending;
@property(nonatomic,retain) SinaWeibo *sinaWeibo;

-(IBAction) buttonPress:(id)sender;
-(void) handleSendContent:(id)sender;
-(NSUInteger) unicodeLengthOfString: (NSString *) text;
@end
