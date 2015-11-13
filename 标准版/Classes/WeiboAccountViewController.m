//
//  WeiboAccountViewController.m
//  du
//
//  Created by MC374 on 12-4-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboAccountViewController.h"
#import "DBOperate.h"
#import "Common.h"
#import "WBEngine.h"
#import "ShareToBlogViewController.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"
#import "JSON.h"
#import "MBProgressHUD.h"

#define oauthMode InWebView
/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expires_in="

@implementation WeiboAccountViewController

@synthesize myTableView;
@synthesize weiboArray;
@synthesize isSinaBinding;
@synthesize isTencentBinding;
@synthesize sinaName;
@synthesize tencentName;
@synthesize weiBoEngine;
@synthesize QQtokenKey;
@synthesize QQtokenSecret;
@synthesize sinaAccessToken;
@synthesize sinaExpireTime;
@synthesize sinaBut;
@synthesize tencentBut;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"微博授权";
    hasOauth = NO;
	myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundView = nil;
    if (IOS_VERSION >= 7.0) {
        myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, 5.0f)];
    }
    // dufu add 2013.06.18
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.separatorColor = [UIColor colorWithRed:[[rgbDictionary objectForKey:moduleLineRed_KEY] floatValue]
                                                    green:[[rgbDictionary objectForKey:moduleLineGreen_KEY] floatValue]
                                                     blue:[[rgbDictionary objectForKey:moduleLineBlue_KEY] floatValue]
                                                    alpha:[[rgbDictionary objectForKey:moduleLineAlpha_KEY] floatValue]];
	
	//检测微博是否已经过期，如果过期的就删除
	NSMutableArray *array = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];
	if(array != nil && [array count] > 0){
		for (int i = 0; i < [array count];i++ ) {
			NSArray *wbArray = [array objectAtIndex:i];
			NSString *type = [wbArray objectAtIndex:weibo_type];
			if ([type isEqualToString:SINA]) {
				int oauthTime = [[wbArray objectAtIndex:weibo_oauth_time] intValue];
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];			
				NSDate *todayDate = [NSDate date]; 
				NSLog(@"Date:%@",todayDate);
				NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
				int time = inter;
				NSLog(@"current time:%d",time);
				NSLog(@"expiresTime:%d",expiredTime);
				NSLog(@"time - oauthTime:%d",time - oauthTime);
				if(expiredTime - (time - oauthTime) <= 0){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}
			}else if ([type isEqualToString:TENCENT]) {
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];
				NSDate *todayDate = [NSDate date]; 
				NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
				NSLog(@"todayDate:%@",todayDate);
				NSLog(@"expirationDate:%@",expirationDate);
				if([todayDate compare:expirationDate] == NSOrderedSame){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}else {
					NSLog(@"not expired");
				}
				
			}
			
		}
	}
	
	self.weiboArray = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil withAll:YES];
	if (weiboArray != nil) {		
		for (int i = 0; i < [weiboArray count]; i++) {
			NSArray *array =	[weiboArray objectAtIndex:i];
			NSString *weiboType = [array objectAtIndex:weibo_type];
			if ([weiboType isEqualToString:SINA]) {
				isSinaBinding = YES;
				self.sinaName = [array objectAtIndex:weibo_user_name];
			}
			if ([weiboType isEqualToString:TENCENT]) {
				isTencentBinding = YES;	
				self.tencentName = [array objectAtIndex:weibo_user_name];
			}
			
		}
		
	}
	
	myTableView.delegate = self;
	myTableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.weiboArray = nil;
	self.sinaName = nil;
	self.tencentName = nil;
	self.weiBoEngine = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
	self.sinaBut = nil;
	self.tencentBut = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.weiboArray = nil;
	self.sinaName = nil;
	self.tencentName = nil;
	self.weiBoEngine = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
	[_webView release];
	[_titleLabel release];    
	[_OpenSdkOauth release];
	_OpenApi.delegate = nil;
//	[_OpenApi release];
    [super dealloc];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 0)
	{
		return 45.0f;
	}
	else 
	{
		return 76.0f;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
		
		if ([indexPath row] == 1) {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新浪" ofType:@"png"]];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60,60 )];
			imageView.image = image;
			[cell.contentView addSubview:imageView];
			[image release];
			[imageView release];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setBackgroundImage:[UIImage imageNamed:@"注销按钮.png"] forState:UIControlStateNormal];
            [but setFrame:CGRectMake(210, 26, 60, 24)];
            [but setTitle: @"注销" forState: UIControlStateNormal];
            but.tag = 200;
            [but setAlpha:0.8];
            self.sinaBut = but;
            [self.sinaBut addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.sinaBut];
            self.sinaBut.hidden = YES;
		}else if ([indexPath row] == 2) {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"腾讯" ofType:@"png"]];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 60,60 )];
			imageView.image = image;
			[cell.contentView addSubview:imageView];
			[image release];
			[imageView release];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setBackgroundImage:[UIImage imageNamed:@"注销按钮.png"] forState:UIControlStateNormal];
            [but setFrame:CGRectMake(210, 26, 60, 24)];
            but.tag = 201;
            [but setTitle: @"注销" forState: UIControlStateNormal];
            [but setAlpha:0.8];
            self.tencentBut = but;
            [self.tencentBut addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.tencentBut];
            self.tencentBut.hidden = YES;
		}		
		
		UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 15 ,150 ,45)];			
		textLable.tag = 100;
		textLable.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1.0];
		textLable.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:textLable];
		[textLable release];
	}
	//NSArray *array = nil;
	UILabel *textLable = (UILabel *)[cell.contentView viewWithTag:100];
	
	if (indexPath.row == 0) {
		[textLable setFrame:CGRectMake(10, 12 ,250 ,20)];
		[textLable setFont:[UIFont systemFontOfSize:12.0f]];
		textLable.textAlignment = UITextAlignmentLeft;
		textLable.text = @"请使用以下方式授权您的微博，分享您的精彩";
	} else if (indexPath.row == 1) {
		if (isSinaBinding) {
			textLable.text = sinaName;
//            UIButton *btn = (UIButton *)[cell.contentView viewWithTag:200];
           self.sinaBut.hidden = NO;
//			if (sinaBut == nil) {
//				
//			}
		}else {
			textLable.text = @"新浪微博授权";
            self.sinaBut.hidden = YES;
		}
	} else {
		if (isTencentBinding) {
			textLable.text = tencentName;
			self.tencentBut.hidden = NO;

		}else {
			textLable.text = @"腾讯微博授权";
            self.tencentBut.hidden = YES;
		}
	}
	return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == 1 && !isSinaBinding) {
//		WBEngine *engine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//		[engine setRootViewController:self];
//		[engine setDelegate:self];
//		[engine setRedirectURI:redirectUrl];
//		[engine setIsUserExclusive:NO];
//		self.weiBoEngine = engine;
//		[engine release];
//		[weiBoEngine logIn];
        
        AppStromAppDelegate *appdelegate =  (AppStromAppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.delegate = self;
        sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:self];
        sinaWeibo.superViewController = self;
        [sinaWeibo logIn];
	}
	if ([indexPath row] == 2 && !isTencentBinding) {
//		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
//		NSString *retString = [api getRequestTokenWithConsumerKey:QQAppKey consumerSecret:QQAppSecret];
//		NSLog(@"Get requestToken:%@", retString);
//		
//		NSDictionary *params = [NSURL parseURLQueryString:retString];
//		self.QQtokenKey = [params objectForKey:@"oauth_token"];
//		self.QQtokenSecret = [params objectForKey:@"oauth_token_secret"];
//		NSString *name = [params objectForKey:@"name"];
//		NSLog(@"QQtokenKey:%@",QQtokenKey);
//		NSLog(@"QQtokenSecret:%@",QQtokenSecret);
//		
//		QVerifyWebViewController *verifyController = [[QVerifyWebViewController alloc] init];
//		verifyController.delegate = self;
//		verifyController.appKey = QQAppKey;
//		verifyController.appSecret = QQAppSecret;
//		verifyController.tokenKey = QQtokenKey;
//		verifyController.tokenSecret = QQtokenSecret;
//		[self.navigationController pushViewController:verifyController animated:YES];
//		[verifyController release];
		
		[self loginWithQQMicroblogAccount];
		
	}
}

- (void) handleCallBack:(NSDictionary*)param
{
    NSURL *url = [param objectForKey:@"url"];
    [sinaWeibo handleOpenURL:url];
    NSString *urlString = [url absoluteString];
    NSString *access_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"access_token"];
    NSString *expires_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
    //NSString *remind_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
    NSString *uid = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"uid"];
    //NSString *refresh_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
    if (uid != nil && [uid length] > 0) {
        //授权完成，调用微博接口获取用户资料
        NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + [expires_in doubleValue];
        self.sinaAccessToken = access_token;
        
        //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
        if(progressHUD == nil ){
            progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        }
        [self.view addSubview:progressHUD];
        [self.view bringSubviewToFront:progressHUD];
        [progressHUD show:YES];
        //授权完成，调用微博接口获取新浪微博用户资料数据
        [sinaWeibo requestWithURL:@"users/show.json"
                           params:[NSMutableDictionary dictionaryWithObject:uid forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
    }
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
    self.sinaAccessToken = sinaWeibo.accessToken;
    if(progressHUD == nil ){
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
    //授权完成，调用微博接口获取新浪微博用户资料数据
    [sinaWeibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"] && !hasOauth)
    {
        hasOauth = YES;
        [self updateWithResult:result];
    }
}


- (void) updateWithResult:(id)result{
    if (progressHUD != nil) {
        [progressHUD removeFromSuperview];
        [progressHUD release];progressHUD = nil;
    }
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
		[ar_weibo addObject:[NSNumber numberWithDouble:[sinaWeibo.expirationDate timeIntervalSince1970]]];
		[ar_weibo addObject:@""];
		[ar_weibo addObject:@""];
		[ar_weibo addObject:sinaAccessToken];
		[ar_weibo addObject:name];
		[ar_weibo addObject:[NSNumber numberWithInt:time]];
		[ar_weibo addObject:@""];
		[ar_weibo addObject:@""];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:SINA];
		[DBOperate insertDataWithnotAutoID:ar_weibo tableName:T_WEIBO_USERINFO];
		[ar_weibo release];
		
		if (delegate != nil) {
			[self.navigationController popViewControllerAnimated:NO];
			[delegate loginSuccess:SINA];
		}else {
			[self updateView];
		}
	}
}

/*
 * 采用两种不同方式进行登录授权,支持webview和浏览器两种方式
 */
- (void) loginWithQQMicroblogAccount{
	short authorizeType = oauthMode; 
	
    _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _OpenSdkOauth.oauthType = authorizeType;
    
    BOOL didOpenOtherApp = NO;
    switch (authorizeType) {
        case InSafari:  //浏览器方式登录授权，不建议使用
        {
            didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
            break;
        }
        case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
        {
            if(!didOpenOtherApp){
                if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
                    NSLog(@"client_id is null");
                    [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
                }
                else
                {
                    [self webViewShow];
                }
                
                [_OpenSdkOauth doWebViewAuthorize:_webView];
                
                break;
            }
        }
        default:
            break;
    }
}


/*
 * 初始化titlelabel和webView
 */
- (void) webViewShow {
    
	//    CGFloat titleLabelFontSize = 14;
	//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	//    _titleLabel.text = @"微博登录";
	//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
	//    _titleLabel.textColor = [UIColor blackColor];
	//    _titleLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
	//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
	//    | UIViewAutoresizingFlexibleBottomMargin;
	//    _titleLabel.textAlignment = UITextAlignmentCenter;
	
	//	[self.view addSubview:_titleLabel];
    
	//    [_titleLabel sizeToFit];
	//    CGFloat innerWidth = self.view.frame.size.width;
	//    _titleLabel.frame = CGRectMake(
	//                                   0,
	//                                   0,
	//                                   innerWidth,
	//                                   _titleLabel.frame.size.height+6);
	
	//    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44)];
    
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_webView];
}


/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;
	
    NSLog(@"response url is %@", url);
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    //如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
		
		NSDate *expirationDate =nil;
		if (expireIn != nil) {
			int expVal = [expireIn intValue];
			_OpenSdkOauth._expireIn_time = expireIn;
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
        
        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
			//授权成功，获取用户数据
			if(_OpenApi == nil){
				_OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey 
											 appSecret:_OpenSdkOauth.appSecret 
										   accessToken:_OpenSdkOauth.accessToken
										  accessSecret:_OpenSdkOauth.accessSecret
												openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
				_OpenApi.delegate = self;
				//Todo:请填写调用user/info获取用户资料接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
                [_OpenApi getUserInfo:@"json"];  //获取用户信息
			}			
        }
        _webView.delegate = nil;
        [_webView setHidden:YES];
        [_titleLabel setHidden:YES];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
    return YES;
}

-(void) getUserInfoSuccess:(NSString*)userInfo{
	NSLog(@"tencent weibo userinfo:%@",userInfo);
	
	SBJSON *jsonParser = [[SBJSON alloc]init];
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:userInfo error:&parseError];
	NSDictionary *dic = [result objectForKey:@"data"];
	if (dic != [NSNull null]) {
		NSString *headImage = [dic objectForKey:@"head"];
		NSString *headImageUrl = [NSString stringWithFormat:@"%@%@",headImage,@"/100"];
		NSString *openid=[dic objectForKey:@"openid"];
		NSString *name=[dic objectForKey:@"name"];
		NSLog(@"headImage:%@",headImageUrl);
		NSLog(@"openid:%@",openid);
		NSLog(@"name:%@",name);
		NSLog(@"accessToken:%@",_OpenSdkOauth.accessToken);
		[jsonParser release];
		
		NSDate *todayDate = [NSDate date]; 
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		
		//获取到的用户资料保存至本地数据库并上传至服务器
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:TENCENT];	
		[ar_wp addObject:@""];
		[ar_wp addObject:[NSNumber numberWithInt:_OpenSdkOauth._expireIn_time]];
		[ar_wp addObject:@"accessToken"];
		[ar_wp addObject:@"accessSecret"];
		[ar_wp addObject:_OpenSdkOauth.accessToken];
		[ar_wp addObject:name];
		[ar_wp addObject:[NSNumber numberWithInt:time]];
		[ar_wp addObject:_OpenSdkOauth.openid];
		[ar_wp addObject:_OpenSdkOauth.openkey];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		if (delegate != nil) {
//			[self.navigationController popViewControllerAnimated:NO];
			[delegate loginSuccess:TENCENT];
		}else {
			[self updateView];
		}


	}
}


#pragma mark -
#pragma mark QVerifyWebViewController delegate
- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.QQtokenKey = [params objectForKey:@"oauth_token"];
	self.QQtokenSecret = [params objectForKey:@"oauth_token_secret"];
	NSString *name = [params objectForKey:@"name"];

	NSDate *todayDate = [NSDate date]; 
	NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
	int time = inter;
	
	//将获取到的数据保存到本地数据库
	NSMutableArray *ar_weibo = [[NSMutableArray alloc]init];
	[ar_weibo addObject:TENCENT];	
	[ar_weibo addObject:@""];
	[ar_weibo addObject:[NSNumber numberWithDouble:_OpenSdkOauth._expireIn_time]];
	[ar_weibo addObject:QQtokenKey];
	[ar_weibo addObject:QQtokenSecret];
	[ar_weibo addObject:@""];
	[ar_weibo addObject:name];
	[ar_weibo addObject:[NSNumber numberWithInt:time]];
	[ar_weibo addObject:@""];
	[ar_weibo addObject:@""];
	[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:TENCENT];
	[DBOperate insertDataWithnotAutoID:ar_weibo tableName:T_WEIBO_USERINFO];
	[ar_weibo release];
	[self updateView];
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
	sinaExpireTime = seconds;
	
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
		[ar_weibo addObject:@""];
		[ar_weibo addObject:@""];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:SINA];
		[DBOperate insertDataWithnotAutoID:ar_weibo tableName:T_WEIBO_USERINFO];
		[ar_weibo release];
		
		if (delegate != nil) {
			[self.navigationController popViewControllerAnimated:NO];
			[delegate loginSuccess:SINA];
		}else {
			[self updateView];
		}
	}
	
}


-(void) handleButtonPress:(id)sender{
	UIButton *but = (UIButton*)sender;
	if (but.tag == 200) {
		[DBOperate deleteData: T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:SINA];
		[weiBoEngine logOut];
		//[but removeFromSuperview];
//		sinaBut = nil;
        
        hasOauth = NO;
	}
	if (but.tag == 201) {
		[DBOperate deleteData: T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:TENCENT];
		//[but removeFromSuperview];
		//tencentBut = nil;
        
        _OpenApi = nil;
	}	
	[self updateView];
}

-(void) updateView{
	weiboArray = nil;
	isSinaBinding = NO;
	sinaName = nil;
	isTencentBinding = NO;
	tencentName = nil;
	self.weiboArray = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil withAll:YES];
	if (weiboArray != nil && [weiboArray  count] > 0) {		
		for (int i = 0; i < [weiboArray count]; i++) {
			NSArray *array =	[weiboArray objectAtIndex:i];
			NSString *weiboType = [array objectAtIndex:weibo_type];
			if ([weiboType isEqualToString:SINA]) {
				isSinaBinding = YES;
				self.sinaName = [array objectAtIndex:weibo_user_name];
			}
			if ([weiboType isEqualToString:TENCENT]) {
				isTencentBinding = YES;	
				self.tencentName = [array objectAtIndex:weibo_user_name];
			}
			
		}
		
	}
	[myTableView reloadData];
}

@end
