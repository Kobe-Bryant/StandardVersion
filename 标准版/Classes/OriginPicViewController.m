//
//  OriginPicViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OriginPicViewController.h"
#import "UIImageScale.h"
#import "browserViewController.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "alertView.h"
#import "Common.h"
#import "spinnerView.h"
#import "WBEngine.h"
#import "ShareToBlogViewController.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "ShareWithQRCodeViewController.h"

@implementation OriginPicViewController
@synthesize originPic;
@synthesize dragger;
@synthesize picName;
@synthesize picArray;
@synthesize toolBar;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize pageControl;
@synthesize scrollview;
@synthesize chooseIndex;
@synthesize showWhichOriginPic;
@synthesize ar_product;
@synthesize actionsheet;
@synthesize indexToPicDic;
@synthesize productId;
@synthesize titleString;
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
- (void)viewDidLoad {
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
	
    if (showWhichOriginPic == SHOW_PRODUCT_PIC){
		self.picArray = (NSMutableArray *)[DBOperate queryData:T_PIC theColumn:@"pid" theColumnValue:productId withAll:NO];
    }
    else {
		self.picArray = (NSMutableArray *)[DBOperate queryData:T_WALLPAPER theColumn:nil theColumnValue:nil  withAll:YES];
	}
	
	
//	NSMutableArray *tbitmp = [[NSMutableArray alloc] initWithArray:self.toolBar.items];
//	self.toolbarItems =  tbitmp;
//	[tbitmp release];
//	self.toolBar.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:0];
//	self.navigationController.toolbar.barStyle = self.toolBar.barStyle;
//	self.navigationController.toolbar.tintColor = self.toolBar.tintColor;
//    self.navigationController.toolbarHidden = NO;
//	[self.navigationController.toolbar setTranslucent:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
	NSMutableDictionary *indextmp = [[NSMutableDictionary alloc]init];
	self.indexToPicDic = indextmp;
	[indextmp release];
	CGRect rect = [[UIApplication sharedApplication] keyWindow].frame;
	
	//设置返回本类按钮
	UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
	tempButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = tempButtonItem ; 
	[tempButtonItem release];
	
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
	UIPageControl *pageCtmp = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 10.0f)];
	self.pageControl = pageCtmp;
	[pageCtmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = [picArray count];
	pageControl.currentPage = chooseIndex;
	pageControl.hidden = YES;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];
    
    int yValue = 0;
    if (IOS_VERSION >= 7.0) {
        yValue = (([UIScreen mainScreen].bounds.size.height - 20 - 460.0f) / 2) + 20;
    }else{
        yValue = (([UIScreen mainScreen].bounds.size.height - 20 - 460.0f) / 2);
    }
	UIScrollView *scrollviewtmp = [[UIScrollView alloc]initWithFrame:CGRectMake( -5.0f, yValue, self.view.frame.size.width + 10.0f, 460.f)];
	self.scrollview = scrollviewtmp;
	[scrollviewtmp release];
	scrollview.contentSize = CGSizeMake(scrollviewtmp.frame.size.width*[picArray count], 460);
	scrollview.delegate = self;
	scrollview.pagingEnabled = YES;
	scrollview.tag = 1000;
	scrollview.showsHorizontalScrollIndicator = NO;
	scrollview.showsVerticalScrollIndicator = NO;
	[self.view addSubview:scrollview];
    
	imageviewTag = 100;
	imageviewTagtmp = 100;
	
	for (int i = 0; i < [picArray count]; i++) {
		myUISCrollView *scrollview1 = [[myUISCrollView alloc]initWithFrame:CGRectMake(i * self.scrollview.frame.size.width + 5.0f, 0 ,320, 460)];
		scrollview1.contentSize = CGSizeMake(320, 460);
		scrollview1.delegate = self;
		scrollview1.mydelegate = self;
		scrollview1.maximumZoomScale = 2.0;
		scrollview1.minimumZoomScale = 1.0;
		scrollview1.showsHorizontalScrollIndicator = NO;
		scrollview1.showsVerticalScrollIndicator = NO;
		scrollview1.tag = 100+i;
        [scrollview addSubview:scrollview1];
        
		myImageView *imageview = [[myImageView alloc]initWithFrame:CGRectMake(0.0f, 0, 320, 460) withImageId:i];
		imageview.tag = 1001;
		imageview.mydelegate = self;
		[scrollview1 addSubview:imageview];
        [imageview release];
        [scrollview1 release];
	}
	scrollview.contentOffset = CGPointMake(self.scrollview.frame.size.width * chooseIndex, 0.0f);
	//NSArray *wp = [picArray objectAtIndex:chooseIndex];
	NSString *s = @"";//@"组图";
	NSString *tString = [titleString stringByAppendingFormat:s];
	NSString *num = [NSString stringWithFormat:@"(%d/%d)",chooseIndex+1,[picArray count]];
	if (tString != nil && [picArray count] > 1) {
		self.title = [tString stringByAppendingFormat:num];
	}else {
		self.title = tString;
	}

	//[num release];
	[self showInCurrentPic:chooseIndex];
    
    [self showToolBar];

}


- (void)showToolBar{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 44, 320.0f, 44.0f)];
    vi.backgroundColor = [UIColor clearColor];
    vi.tag = 3005;
    [self.view addSubview:vi];
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:  
							CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    if (IOS_VERSION >= 7.0) {
        myToolBar.barTintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1.0];
    }else {
        myToolBar.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1.0];
    }
	[vi addSubview:myToolBar];
    [vi release];
	
	NSMutableArray *buttons=[[NSMutableArray  alloc]init];  
	[buttons  autorelease];  
	
	UIBarButtonItem   *SpaceButton1=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton1];  
	[SpaceButton1 release];  
	
	UIBarButtonItem   *freshButton=[[UIBarButtonItem alloc]  initWithTitle: @"详情" style: UIBarButtonItemStyleBordered target:self   action:@selector(HandleToBrowser:)];
	[buttons addObject:freshButton];  
	[freshButton release];   
	UIBarButtonItem   *SpaceButton2=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton2];  
	[SpaceButton2 release];  
	
	UIBarButtonItem   *searchSelfButton=[[UIBarButtonItem alloc] initWithTitle: @"保存到相册" style: UIBarButtonItemStyleBordered target:self   action:@selector(HandleLoadDown:)];
	[buttons addObject:searchSelfButton];  
	[searchSelfButton release];  
	
	UIBarButtonItem   *SpaceButton3=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton3];  
	[SpaceButton3 release];
    
    UIBarButtonItem   *shareSelfButton=[[UIBarButtonItem alloc] initWithTitle: @"分享" style: UIBarButtonItemStyleBordered target:self   action:@selector(HandleShare:)];
	[buttons addObject:shareSelfButton];
	[shareSelfButton release];
	
	UIBarButtonItem   *SpaceButton4=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];
	[buttons addObject:SpaceButton4];
	[SpaceButton4 release];
	
	[myToolBar setItems:buttons animated:YES];  
	[myToolBar  sizeToFit]; 
	[myToolBar release];
	
}


-(void)showInCurrentPic:(int)curPic{
	NSLog(@"showIn current %d",curPic);
	[self showOnePic:curPic];
	[self showOnePic:(curPic-1)];
	[self showOnePic:(curPic+1)];
	[self removeOnePic:(curPic-2)];
	[self removeOnePic:(curPic+2)];
}
-(void)removeOnePic:(int)picIndex{
	if ((picIndex >=0) && (picIndex < [picArray count])) {
    	UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(picIndex+100)];
    	[indexToPicDic removeObjectForKey:[NSNumber numberWithInt:picIndex]];
    	myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
    	myIV.image = nil;
	}
}
-(void)showOnePic:(int)picIndex{
		
if ((picIndex >=0) && (picIndex < [picArray count])) {
		UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(picIndex+100)];
		myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
		if(myIV.image == nil){
				
         	NSArray *wp = [picArray objectAtIndex:picIndex];
        	if (showWhichOriginPic == SHOW_PRODUCT_PIC) {
	         	[self loadpic:wp withIndex:picIndex];
        	}
    	    else {
    	    	[self loadWallPaper:wp withIndex:picIndex];
     	    }
		}
	}
}
-(void)loadWallPaper:(NSArray*)wp withIndex:(int)index{

	if (((NSString*)[wp objectAtIndex:wallpaper_pic_name]).length > 1) {
		
    	UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(index+100)];
        myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
    	UIImage *photo = [FileManager getPhoto:[wp objectAtIndex:wallpaper_pic_name]];
    	if (photo!=nil) {
			[indexToPicDic setObject:photo forKey:[NSNumber numberWithInt:index]];
    		myIV.image = [photo fillSize:CGSizeMake(scrollview.frame.size.width, scrollview.frame.size.height)];
    	}
    	else {
    		[self startIconDownload: [wp objectAtIndex:wallpaper_pic_url] forIndex:[NSIndexPath indexPathWithIndex:index]];
    	}
	}
	else {
    	[self startIconDownload: [wp objectAtIndex:wallpaper_pic_url] forIndex:[NSIndexPath indexPathWithIndex:index]];
		
    }
	
}
-(void)loadpic:(NSArray*)wp withIndex:(int)index{

	if (((NSString*)[wp objectAtIndex:originpic_pic1_name]).length > 1) {
	
    	UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(index+100)];
        myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
    	UIImage *photo = [FileManager getPhoto:[wp objectAtIndex:originpic_pic1_name]];
		//NSLog(@"%d,%d",scrollview.frame.size.width,scrollview.frame.size.height);
    	if (photo!=nil) {
			[indexToPicDic setObject:photo forKey:[NSNumber numberWithInt:index]];
			if(myIV.image.size.width == scrollview.frame.size.width && myIV.image.size.height == scrollview.frame.size.height){
				
			}else{
				myIV.image = [photo fillSize:CGSizeMake(scrollview.frame.size.width, scrollview.frame.size.height)];
			}
    	}
    	else {
    		[self startIconDownload: [wp objectAtIndex:originpic_pic1_url] forIndex:[NSIndexPath indexPathWithIndex:index]];
    	}
     }
   else {
    	[self startIconDownload: [wp objectAtIndex:originpic_pic1_url] forIndex:[NSIndexPath indexPathWithIndex:index]];
	
    }
}


- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	[spinnerView startSpinner:self.view];
	NSLog(@"imgurl %@",index);
	//NSLog(@"startload index %@",index);
	
    if (imageURL != nil && imageURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= MAXICONDOWNLOADINGNUM) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
		if ([imageDownloadsInProgress objectForKey:index]==nil) {
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgress setObject:iconDownloader forKey:index];
			
			[iconDownloader startDownload];
			[iconDownloader release];   
		}
       
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
	[spinnerView stopSpinner];
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width>2.0){ 
			NSString *photoname = [callSystemApp getCurrentTime];
			if([FileManager savePhoto:photoname withImage:iconDownloader.cardIcon])
			{
				NSArray *one = [picArray objectAtIndex:[indexPath indexAtPosition:0]]; 
				//NSLog(@"one %@ %d",one,category_id);
				if (showWhichOriginPic == SHOW_PRODUCT_PIC){
					NSNumber *value = [one objectAtIndex:originpic_id];
					[FileManager removeFile:[one objectAtIndex:originpic_pic1_name]];
					[DBOperate updateData:T_PIC tableColumn:@"pic1_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
				    self.picArray = (NSMutableArray *)[DBOperate queryData:T_PIC theColumn:@"pid" theColumnValue:productId withAll:NO];
				}
				else {
					NSNumber *value = [one objectAtIndex:wallpaper_id];
					[FileManager removeFile:[one objectAtIndex:wallpaper_pic_name]];
					[DBOperate updateData:T_WALLPAPER tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
					self.picArray = (NSMutableArray *)[DBOperate queryData:T_WALLPAPER theColumn:nil theColumnValue:nil  withAll:YES];
				}
				

			}
			
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(scrollview.frame.size.width, scrollview.frame.size.height)];
			NSUInteger index;
			[indexPath getIndexes:&index];
			NSLog(@"index...................... %lu",(unsigned long)index);
			UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(index+100)];
			[indexToPicDic setObject:iconDownloader.cardIcon forKey:[NSNumber numberWithInt:index]];
			myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
			myIV.image = photo;
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//	self.navigationController.toolbarHidden = YES;
//	[self.navigationController.toolbar setTranslucent:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(IBAction)HandleToBrowser:(id)sender{
	browserViewController *browser = [[browserViewController alloc]init];
	browser.isHideToolbar = NO;
	
	if (showWhichOriginPic == SHOW_PRODUCT_PIC) {
		
		browser.linkurl = [ar_product objectAtIndex:product_url];
		browser.linktitle = [ar_product objectAtIndex:product_name];
		browser.isFirstLoad = NO;
		//NSLog(browser.linktitle);
		[self.navigationController pushViewController:browser animated:YES];
		
	}
	else {
	NSArray *wp = [picArray objectAtIndex:pageControl.currentPage];
		
		browser.linkurl = [wp objectAtIndex:wallpaper_pic_url];
		browser.linktitle = [wp objectAtIndex:wallpaper_title];
		[self.navigationController pushViewController:browser animated:YES];
	}
	
	[browser release];
}
-(IBAction)HandleLoadDown:(id)sender{
	UIImage *photo = [indexToPicDic objectForKey:[NSNumber numberWithInt:pageControl.currentPage]];
	if (photo == nil) {
		[alertView showAlert:@"无法保存到本地相册"];
	}
	else {
		UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [alertView showAlert:@"保存成功"];
	}

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; 
{
	if (!error) 
		NSLog(@"Image written to photo album");
	else
		NSLog(@"Error writing to photo album: %@", [error localizedDescription]);
}
- (void)getChoosedIndex:(int)index{
	NSString *linktitle;
	NSString *linkurl;
	if (showWhichOriginPic == SHOW_PRODUCT_PIC) {
		linkurl = [ar_product objectAtIndex:product_url];
		linktitle = [ar_product objectAtIndex:product_name];
		
	}
	else {
		NSArray *wp = [picArray objectAtIndex:pageControl.currentPage];
		linkurl = [wp objectAtIndex:wallpaper_pic_url];
		linktitle = [wp objectAtIndex:wallpaper_title];
	}
	
	NSString *param = [NSString stringWithString:SHARE_CONTENT];
	
	NSString *shareContent = [NSString stringWithFormat:@"[%@]  %@",linktitle,[ar_product objectAtIndex:product_url]];
	shareContent = [param stringByAppendingString:shareContent];
	
	switch (index) {
		case 0:
		{
			[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:shareContent];
			
		}
            break;
		case 1:
		{////收件人，cc：抄送  subject：主题   body：内容
			[callSystemApp sendEmail:@"" cc:@"" subject:SHARE_CONTENT body:shareContent];
			
		}
            break;
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
				UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(pageControl.currentPage + 100)];
				myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
				UIImage *img = myIV.image;
				share.shareImage = img;
				share.checkBoxSelected =YES;
				NSString *content = [ar_product objectAtIndex:product_name];
				NSString *param = [NSString stringWithString:SHARE_CONTENT];
				NSString *param1 = [NSString stringWithFormat:@"[%@]  %@",content,[ar_product objectAtIndex:product_url]];
				param1 = [param stringByAppendingString:param1];
				share.defaultContent = param1;
//				share.engine = wbengine;
                share.sinaWeibo = weibo;
                [weibo release];
				share.weiBoType = 0;
				[self.navigationController pushViewController:share animated:YES];
				[share release];
				
			}else {
//				NSLog(@"SinaAppKey:%@",SinaAppKey);
//				NSLog(@"SinaAppSecret:%@",SinaAppSecret);
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
		}
            break;
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
				UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(pageControl.currentPage + 100)];
				myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
				UIImage *img = myIV.image;
				share.shareImage = img;
				share.checkBoxSelected =YES;
				share.qAccessToken = accessToken;
				share.qOpenid = openid;
				share.qWeiboUserName = username;
				NSString *content = [ar_product objectAtIndex:product_name];
				NSString *param = [NSString stringWithString:SHARE_CONTENT];
				NSString *param1 = [NSString stringWithFormat:@"[%@]  %@",content,[ar_product objectAtIndex:product_url]];
				param1 = [param stringByAppendingString:param1];
				share.defaultContent = param1;
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

			
		}
            break;
		case 4:			
		{
			ShareWithQRCodeViewController *share = [[ShareWithQRCodeViewController alloc]init];
			share.linkurl = [ar_product objectAtIndex:product_url];
			share.linktitle = self.titleString;
			[self.navigationController pushViewController:share animated:YES];
			[share release];
		}
            break;
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
		UIScrollView *subscroll = (UIScrollView *)[scrollview viewWithTag:(pageControl.currentPage + 100)];
		myImageView *myIV = (myImageView *)[subscroll viewWithTag:1001];
		UIImage *img = myIV.image;
		share.shareImage = img;
		share.checkBoxSelected =YES;
		share.weiBoType = 0;
		NSString *content = [ar_product objectAtIndex:product_name];
		NSString *param = [NSString stringWithString:SHARE_CONTENT];
		NSString *param1 = [NSString stringWithFormat:@"[%@]  %@",content,[ar_product objectAtIndex:product_url]];
		param1 = [param stringByAppendingString:param1];
		share.defaultContent = param1;
		share.engine = weiBoEngine;
		[self.navigationController pushViewController:share animated:YES];
		[share release];
	}
	
}


-(IBAction)HandleShare:(id)sender{
	NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享给手机用户",@"分享给邮箱联系人",@"分享到新浪微博",@"分享到腾讯微博",@"二维码分享",nil];
	manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	actionsheet1.manageDeleage = self;
	self.actionsheet = actionsheet1;
	[actionsheet1 release];
	[actionsheet showActionSheet:self.view];
	
}
/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"%s", _cmd);
    
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2)
    {
        //NSLog(@"double click");
        
        CGFloat zs = self.zoomScale;
        zs = (zs == 1.0) ? 2.0 : 1.0;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];            
        self.zoomScale = zs;    
        [UIView commitAnimations];
    }
}*/
-(void)touchOnce{

	BOOL navBarState = [self.navigationController isNavigationBarHidden];
	[self.navigationController setNavigationBarHidden:!navBarState animated:YES];
    
    UIView *toolview = (UIView *)[self.view viewWithTag:3005];
	[toolview setHidden:!navBarState];
}
- (void)imageViewTouchesEnd:(int)picId{

/*	BOOL navBarState = [self.navigationController isNavigationBarHidden];
	[self.navigationController setNavigationBarHidden:!navBarState animated:YES];
    [self.navigationController setToolbarHidden:!navBarState animated:YES];*/
}
/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
	NSLog(@"scroll");
	if (aScrollView.tag == 1000) {
		CGPoint offset = aScrollView.contentOffset;
		int x = offset.x;
		int width = aScrollView.frame.size.width;
		
		int xx = x / width;
		int yy = x % width;
		if (yy > aScrollView.frame.size.width/2) {
			xx++;
		}
		NSLog(@"yy %d ",xx);
		CGPoint p = CGPointMake(xx*aScrollView.frame.size.width, offset.y);
		[aScrollView setContentOffset:p animated:YES];
		imageviewTagtmp =imageviewTag+offset.x / aScrollView.frame.size.width;
		
	}
	
}*/
- (void) pageTurn: (UIPageControl *) aPageControl
{
	NSLog(@"come to pageturn");
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	scrollview.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
	
}
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	
	
	if(aScrollView.tag == 1000){
		CGPoint offset = aScrollView.contentOffset;
		pageControl.currentPage = offset.x / self.view.frame.size.width;
		//
		NSString *s = @"";//@"组图";
		NSString *tString = [titleString stringByAppendingFormat:s];
		NSString *num = [NSString stringWithFormat:@"(%d/%d)",pageControl.currentPage + 1,[picArray count]];
		if (tString != nil && [picArray count] > 1) {
			self.title = [tString stringByAppendingFormat:num];
		}else {
			self.title = tString;
		}
		
		//[self performSelector:@selector(showInCurrentPic:) withObject:pageControl.currentPage afterDelay:0.1];
		[self showInCurrentPic:pageControl.currentPage];
	}
	//wallpaper *wp = [picArray objectAtIndex:pageControl.currentPage];
	//[self startIconDownload:wp.pic forIndex:[NSIndexPath indexPathWithIndex:pageControl.currentPage]];

}

/*- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	if (aScrollView.tag == 1000) {
		CGPoint offset = aScrollView.contentOffset;
		int x = offset.x;
		int width = aScrollView.frame.size.width;
		
		int xx = x / width;
		int yy = x % width;
		if (yy > aScrollView.frame.size.width/2) {
			xx++;
		}
		CGPoint p = CGPointMake(xx*aScrollView.frame.size.width, offset.y);
		[aScrollView setContentOffset:p animated:YES];
		//float x = offset.x / aScrollView.frame.size.width; 
		//aScrollView.contentOffset = offset.x%aScrollView.frame.size.width>aScrollView.frame.size.width?
		imageviewTagtmp =imageviewTag+offset.x / aScrollView.frame.size.width;

	}
}*/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
   	if (scrollView.tag == 1000) {
		return nil;
	}
	UIImageView *imageview = (UIImageView *)[scrollView viewWithTag:1001];
	return imageview;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
	NSLog(@"scele %f",scale);
	if (scrollView.tag != 1000) {
		UIImage *photo = [indexToPicDic objectForKey:[NSNumber numberWithInt:(scrollView.tag-100)]];
		float pwidth = scrollView.frame.size.width*scale;
		float pheigth = scrollView.frame.size.height*scale;
	/*	float pwidth = photo.size.width;
		float pheigth = photo.size.height;
		if (scrollView.frame.size.width*scale<pwidth) {
			pwidth = scrollView.frame.size.width*scale;
		}
		else {
			pwidth = scrollView.frame.size.width;
		}

		if (scrollView.frame.size.height*scale<pheigth) {
			pheigth = scrollView.frame.size.height*scale;
		}
		else {
			pheigth = scrollView.frame.size.height;
		}



		UIImageView *imageview = (UIImageView*)view;
		float vwidth = scrollView.frame.size.width;
		float vheight = scrollView.frame.size.height;
		if(pwidth>vwidth)
		{
			vwidth = pwidth;
		}
		if (pheigth>vheight) {
			vheight = pheigth;
		}*/
			UIImageView *imageview = (UIImageView*)view;
		scrollView.contentSize = CGSizeMake(pwidth,pheigth);// dragger.frame.size;
		imageview.frame =CGRectMake(0, 0, pwidth, pheigth);// CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);
		//NSArray *wp = [picArray objectAtIndex:pageControl.currentPage];
		

	/*	if (showWhichOriginPic == SHOW_PRODUCT_PIC) {
			photo = [FileManager getPhoto:[wp objectAtIndex:originpic_pic1_name]];
		}
		else {
			photo = [FileManager getPhoto:[wp objectAtIndex:wallpaper_pic_name]];
		}
		*/
		imageview.image= [photo fillSize:CGSizeMake(pwidth, pheigth)];
		
	}
	
}
-(IBAction)turnBack:(id)sender{

	[self dismissModalViewControllerAnimated:YES];
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
	self.titleString = nil;
	self.picArray = nil;
	self.indexToPicDic = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.pageControl = nil;
	for (UIView *innerview in [self.scrollview subviews]){
		[innerview removeFromSuperview];
	}
    self.scrollview = nil;
	self.toolBar = nil;
	self.weiBoEngine = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.titleString = nil;
	self.picArray = nil;
	self.originPic = nil;
	self.dragger = nil;
	self.picName = nil;
	self.toolBar = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.weiBoEngine = nil;
	self.imageDownloadsInProgress=nil;
	self.imageDownloadsInWaiting=nil;
	self.pageControl = nil;
	for (UIView *innerview in [self.scrollview subviews]){
		
			for (UIView *iinner in [innerview subviews]){
				[iinner removeFromSuperview];
			}
		
		[innerview removeFromSuperview];
	}
	
	self.scrollview = nil;
	self.ar_product = nil;
	self.actionsheet = nil;
	self.indexToPicDic = nil;
	self.productId = nil;
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.sinaAccessToken = nil;
    [super dealloc];
}


@end
