//
//  browserViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "browserViewController.h"

#import <MessageUI/MessageUI.h>
#import "alertView.h"
#import "callSystemApp.h"
#import "Common.h"
#import "WBEngine.h"
#import "ShareToBlogViewController.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "DBOperate.h"
#import "ShareWithQRCodeViewController.h"


@implementation browserViewController
@synthesize progressHUD;
@synthesize actionsheet;
@synthesize linkurl;
@synthesize linktitle;
@synthesize ButtonItem;
@synthesize webView;
@synthesize testtb;
@synthesize isHideToolbar;
@synthesize isFirstLoad;
@synthesize weiBoEngine;
@synthesize QQtokenKey;
@synthesize QQtokenSecret;
@synthesize sinaAccessToken;
@synthesize sinaExpireTime;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewHeight = [UIScreen mainScreen].bounds.size.height - 44.0f - 20.0f;
    
	isFirstLoad = YES;
	UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
	self.ButtonItem = tempButtonItem;
	tempButtonItem .title = @"返回";
	self.navigationItem.backBarButtonItem = tempButtonItem ; 
	[tempButtonItem release];

    testtb.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:0]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"23232.png"]];
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"向前",@"向后",nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	CGRect rect=CGRectMake(0.0f, 0.0f, 150.0f, 30.0f);
	segmentedControl.frame=rect;
	segmentedControl.momentary = YES; 
	//segmentedControl.tintColor=[UIColor brownColor];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *contactSegment = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
	//segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.rightBarButtonItem = contactSegment;
	[segmentedControl release];
	[contactSegment release];
	[self setSegmentEnable];
    
    CGFloat height = 0.0f;
	if(isHideToolbar){
		height = viewHeight;
	}else {
		height = viewHeight - 44.0f;
        [self showToolBar];
	}
	
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, 320, height)];
	self.webView = webview;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[webview release];
    
    if ([self.linkurl length] > 1)
	{
		//开始请求连接
		NSURL *webUrl =[NSURL URLWithString:self.linkurl];
		NSURLRequest *request =[NSURLRequest requestWithURL:webUrl];
		[webView loadRequest:request];
	}
    
	//MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, -44 ,320 , 460)];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";

}

- (void)showToolBar{
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:  
							CGRectMake(0.0f, viewHeight - 44, 320.0f, 44.0f)];
    if (IOS_VERSION >= 7.0) {
        myToolBar.barTintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1.0];
    }else {
        myToolBar.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1.0];
    }
    
	[self.view addSubview:myToolBar];
	
	NSMutableArray *buttons=[[NSMutableArray  alloc]initWithCapacity:3];  
	[buttons  autorelease];  
	
	UIBarButtonItem   *SpaceButton1=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton1];  
	[SpaceButton1 release];  
	
	UIBarButtonItem   *freshButton=[[UIBarButtonItem alloc]  initWithTitle: @"分享" style: UIBarButtonItemStyleBordered target:self   action:@selector(share:)];  
	[buttons addObject:freshButton];  
	[freshButton release];   
	UIBarButtonItem   *SpaceButton2=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton2];  
	[SpaceButton2 release];  
	
	UIBarButtonItem   *searchSelfButton=[[UIBarButtonItem alloc] initWithTitle: @"刷新" style: UIBarButtonItemStyleBordered target:self   action:@selector(reload:)];  
	[buttons addObject:searchSelfButton];  
	[searchSelfButton release];  
	
	UIBarButtonItem   *SpaceButton3=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton3];  
	[SpaceButton3 release]; 
	
	[myToolBar setItems:buttons animated:YES];  
	[myToolBar  sizeToFit]; 
	[myToolBar release];
}

//- (void)hideToolBar{
//	UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, 320, viewHeight)];
//	self.webView = webview;
//	webView.delegate = self;
//	webView.scalesPageToFit = YES;
//	[self.view addSubview:webView];
//	[webview release];
//}


-(void)loadURL:(NSString*)str_URL{

	if (str_URL.length > 0) {
		NSURL *url = [[NSURL alloc] initWithString:str_URL];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
		[webView loadRequest: request];
		[request release];
		[url release];
		//[self webViewDidStartLoad : webView];
	}
}
-(IBAction)reload:(id)sender{
	[webView reload];
}
-(IBAction)search:(id)sender{
	[self loadURL:@"http://yy.3g.cn/"];
}
-(IBAction)share:(id)sender{
	NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享给手机用户",@"分享给邮箱联系人",@"分享到新浪微博",@"分享到腾讯微博",@"二维码分享",nil];
	manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	actionsheet1.manageDeleage = self;
	self.actionsheet = actionsheet1;
	[actionsheet1 release];
	[actionsheet showActionSheet:self.navigationController.navigationBar];	
}

- (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",to, cc, subject, body];
	str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)getChoosedIndex:(int)index{

	NSString *param = [NSString stringWithString:SHARE_CONTENT];
	NSString *param1;
	if ([linktitle isEqualToString:@""]) {
		param1 = linkurl;
	}else {
		param1 = [NSString stringWithFormat:@"[%@]  %@",linktitle,linkurl];
	}

	//NSLog(linktitle);
	param1 = [param stringByAppendingString:param1];
	param = [Common URLEncodedString:param1];
	
	switch (index) {
		case 0:
		{
			[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:param1];
			break;
		}
		case 1:
		{////收件人，cc：抄送  subject：主题   body：内容
			[callSystemApp sendEmail:@"" cc:@"" subject:SHARE_CONTENT body:param1];
			
			break;
		}
		case 2:
		{
			NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:SINA withAll:NO];
			NSArray *array = nil;
			
			if(weiboArray != nil && [weiboArray count] > 0){
				array = [weiboArray objectAtIndex:0];
				int oauthTime = [[array objectAtIndex:weibo_oauth_time] intValue];
				int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
				NSString *type = [array objectAtIndex:weibo_type];
				NSDate *todayDate = [NSDate date]; 
				NSLog(@"Date:%@",todayDate);
				NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
				int time = inter;
				NSLog(@"current time:%d",time);
				NSLog(@"expiresTime:%d",expiredTime);
				NSLog(@"time - oauthTime:%d",time - oauthTime);
				if(expiredTime - (time - oauthTime) <= 0){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
					weiboArray = nil;
				}
			}
			
			if (weiboArray != nil && [weiboArray count] > 0) {
				array = [weiboArray objectAtIndex:0];
				NSString *accessToken = [array objectAtIndex:weibo_access_token];
				double expiresTime = [[array objectAtIndex:weibo_expires_time] doubleValue];
				NSString *uid = [array objectAtIndex:weibo_user_id];
                
                SinaWeibo *weibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:nil];
                weibo.userID = uid;
                weibo.accessToken = accessToken;
                weibo.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiresTime];
                
//				WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//				wbengine.accessToken = accessToken;
//				wbengine.userID = uid; 
//				wbengine.expireTime = expiresTime;
				//已经绑定了微博账号，调用新浪微博分享界面
				ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
				share.shareImage = nil;
				share.defaultContent = param1;
//				share.engine = wbengine;
                share.sinaWeibo = weibo;
                [weibo release];
				share.weiBoType = 0;
				[self.navigationController pushViewController:share animated:YES];
				[share release];
				
			}else {
//				WBEngine *engine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//				[engine setRootViewController:self];
//				[engine setDelegate:self];
//				[engine setRedirectURI:redirectUrl];
//				[engine setIsUserExclusive:NO];
//				self.weiBoEngine = engine;
//				[engine release];
//				[weiBoEngine logIn];
				
				WeiboAccountViewController *weiboAccount = [[WeiboAccountViewController alloc] init];
				weiboAccount.delegate = self;
				[self.navigationController pushViewController:weiboAccount animated:YES];
				[weiboAccount release];
				
			}
			break;
		}
		case 3:
		{			
			NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:TENCENT withAll:NO];
			NSArray *array = nil;
			
			if(weiboArray != nil && [weiboArray count] > 0){
				int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
				NSDate *todayDate = [NSDate date]; 
				NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
				NSLog(@"todayDate:%@",todayDate);
				NSLog(@"expirationDate:%@",expirationDate);
				if([todayDate compare:expirationDate] == NSOrderedSame){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:TENCENT];
					weiboArray = nil;
				}else {
					NSLog(@"not expired");
				}
			}
			
			if (weiboArray != nil && [weiboArray count] > 0) {
				array = [weiboArray objectAtIndex:0];
				NSString *accessToken = [array objectAtIndex:weibo_access_token];
				NSString *openid = [array objectAtIndex:weibo_open_id];
				NSString *username = [array objectAtIndex:weibo_user_name];
				ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
				share.shareImage = nil;
				share.defaultContent = param1;
				share.qAccessToken = accessToken;
				share.qOpenid = openid;
				share.qWeiboUserName = username;
				share.weiBoType = 1;
				[self.navigationController pushViewController:share animated:YES];
				[share release];
			}else{				
//				QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
//				NSString *retString = [api getRequestTokenWithConsumerKey:QQAppKey consumerSecret:QQAppSecret];
//				NSLog(@"Get requestToken:%@", retString);
//				
//				NSDictionary *params = [NSURL parseURLQueryString:retString];
//				self.QQtokenKey = [params objectForKey:@"oauth_token"];
//				self.QQtokenSecret = [params objectForKey:@"oauth_token_secret"];
//				NSString *name = [params objectForKey:@"name"];
//				NSLog(@"QQtokenKey:%@",QQtokenKey);
//				NSLog(@"QQtokenSecret:%@",QQtokenSecret);
//				
//				QVerifyWebViewController *verifyController = [[QVerifyWebViewController alloc] init];
//				verifyController.delegate = self;
//				verifyController.appKey = QQAppKey;
//				verifyController.appSecret = QQAppSecret;
//				verifyController.tokenKey = QQtokenKey;
//				verifyController.tokenSecret = QQtokenSecret;
//				[self.navigationController pushViewController:verifyController animated:YES];
//				[verifyController release];
				
				WeiboAccountViewController *weiboAccount = [[WeiboAccountViewController alloc] init];
				weiboAccount.delegate = self;
				[self.navigationController pushViewController:weiboAccount animated:YES];
				[weiboAccount release];
				
			}
			
			break;
		}
		case 4:			
		{
			ShareWithQRCodeViewController *share = [[ShareWithQRCodeViewController alloc]init];
			share.linkurl = self.linkurl;
			share.linktitle = self.linktitle;
			//NSLog(linktitle);
			[self.navigationController pushViewController:share animated:YES];
			[share release];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark LoginViewController delegate

-(void)loginSuccess:(NSString*)withLoginType{
	if ([withLoginType isEqualToString:SINA]) {
		[self getChoosedIndex:2];
	}else if ([withLoginType isEqualToString:TENCENT]) {
		[self getChoosedIndex:3];
	}
}

#pragma mark - WBEngineDelegate Methods
#pragma mark Authorize

- (void)engineDidLogIn:(WBEngine *)engine didSucceedWithAccessToken:(NSString *)accessToken userID:(NSString *)userID expiresIn:(NSInteger)seconds
{
	NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + seconds;	
	NSLog(@"OriginalViewController");
	NSLog(@"accessToken:%@",accessToken);
	NSLog(@"userID:%@",userID);
	NSLog(@"expiresIn:%f",expireTime);
	self.sinaAccessToken = accessToken;
	sinaExpireTime = expireTime;
	
	//	授权完成，调用微博接口获取新浪微博用户资料数据
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"uid",nil];
	[weiBoEngine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:params postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
	//获取到用户数据，双传至服务器
	NSLog(@"requestDidSucceedWithResult");
	if ([result isKindOfClass:[NSDictionary class]])
    {
		NSDictionary *dic = (NSDictionary*)result;
		NSString *userId = [dic objectForKey:@"id"];
		//NSString *screen_name=[dic objectForKey:@"screen_name"];
		NSString *name=[dic objectForKey:@"name"];
//		NSString *province=[[dic objectForKey:@"province"]intValue];
//		NSString *city=[[dic objectForKey:@"city"]intValue];
//		NSString *location=[dic objectForKey:@"location"];
//		NSString *description=[dic objectForKey:@"description"];
//		NSString *url=[dic objectForKey:@"url"];
//		NSString *profile_image_url=[dic	objectForKey:@"profile_image_url"];
//		NSString *domain=[dic objectForKey:@"domain"];
		
		NSDate *todayDate = [NSDate date]; 
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		
		NSMutableArray *ar_weibo = [[NSMutableArray alloc]init];
		[ar_weibo addObject:SINA];	
		[ar_weibo addObject:userId];
		[ar_weibo addObject:[NSNumber numberWithDouble:sinaExpireTime]];
		[ar_weibo addObject:@""];
		[ar_weibo addObject:@""];
		[ar_weibo addObject:sinaAccessToken];
		[ar_weibo addObject:name];
		[ar_weibo addObject:[NSNumber numberWithInt:time]];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:SINA];
		[DBOperate insertDataWithnotAutoID:ar_weibo tableName:T_WEIBO_USERINFO];
		[ar_weibo release];
		
		ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
		share.shareImage = nil;
		share.checkBoxSelected = NO;
		share.weiBoType = 0;
		NSString *param = [NSString stringWithString:SHARE_CONTENT];
		NSString *param1;
		if ([linktitle length] > 0) {
			param1 = [NSString stringWithFormat:@"[%@]  %@",linktitle,linkurl];	
		}else {
			param1 = linkurl;
		}
		param1 = [param stringByAppendingString:param1];
		share.shareImage = nil;
		share.defaultContent = param1;
		share.engine = weiBoEngine;
		[self.navigationController pushViewController:share animated:YES];
		[share release];
	}
	
}


- (BOOL)webView:(UIWebView *)webView1 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//self.linkurl=[[request URL]absoluteString];
	NSLog(@"linkurl %@",linkurl);
	return YES;
}	
-(void)setSegmentEnable{
	UISegmentedControl *contactSegment= (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
	if ([webView canGoBack]) {
		[contactSegment setEnabled:YES forSegmentAtIndex:0];
	}
	else {
		[contactSegment setEnabled:NO forSegmentAtIndex:0];
	}
	
	if ([webView canGoForward]) {
		[contactSegment setEnabled:YES forSegmentAtIndex:1];
	}
	else {
		[contactSegment setEnabled:NO forSegmentAtIndex:1];
	}
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
	}	
	if (isFirstLoad) {
		self.linktitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if (![linktitle length] > 0) {
			linktitle = @"返回";
		}
	}
	isFirstLoad = NO;
	
//	if ([linktitle length] == 0) {
//		ButtonItem.title = @"返回";
//	}else {
//		ButtonItem.title = linktitle;
//	}

	[self setSegmentEnable];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	
	[self.progressHUD show:YES];
}
-(void)segmentAction:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch ([segmentedControl selectedSegmentIndex]) 
	{
		case 0:
		{
			[webView goBack];	
		break;
		}
		case 1:
		{
			[webView goForward];
			break;
		}

	}
	[self setSegmentEnable];

}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.webView = nil;
	self.testtb = nil;
	self.ButtonItem = nil;
	self.progressHUD = nil;
	self.weiBoEngine = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	webView.delegate = nil;
	self.progressHUD = nil;
	self.actionsheet = nil;
	self.linkurl = nil;
	self.linktitle = nil;
	self.ButtonItem = nil;
	self.webView = nil;
	self.testtb = nil;
	weiBoEngine.delegate = nil;
	self.weiBoEngine = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
    [super dealloc];
}


@end
