//
//  ShareToBlogViewController.m
//  du
//
//  Created by MC374 on 12-4-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareToBlogViewController.h"
#import "Common.h"
#import "alertView.h"
#import "FileManager.h"

#define oauthMode InWebView

@implementation ShareToBlogViewController

@synthesize myTextView;
@synthesize imageButton;
@synthesize selectButton;
@synthesize checkBoxSelected;
@synthesize defaultContent; 
@synthesize shareImage;
@synthesize sinaAccessToken;
@synthesize engine;
@synthesize qAccessToken;
@synthesize qOpenid;
@synthesize qWeiboUserName;
@synthesize weiBoType;
@synthesize connection;
@synthesize progressHUD;
@synthesize sendLabel;
@synthesize backImageView;
@synthesize sendButton;
@synthesize textViewBackImageView;
@synthesize isStillSending;
@synthesize sinaWeibo;

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
	[selectButton setImage:[UIImage imageNamed:@"选择2.png"] forState:UIControlStateNormal];
	[imageButton setImage:shareImage forState:UIControlStateNormal];
	myTextView.text = [NSString stringWithFormat:@"%@%@", @"\n",defaultContent];
	NSInteger index = 140;
	if ([defaultContent length] > 140) {
		myTextView.text = [defaultContent substringToIndex:index - 1];
	}
	NSRange range;
	range.location = 0;
	range.length = 0;
	myTextView.selectedRange = range;
	[myTextView becomeFirstResponder];
	myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor clearColor];
    
//    NSLog(@"screen Viewheight:%f",[UIScreen mainScreen].bounds.size.height);
//    if ([UIScreen mainScreen].bounds.size.height > 480) {
//        [textViewBackImageView removeFromSuperview];
//        UIImageView *big = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44-49-20-216-imageButton.frame.size.height+23)];
//        UIImage *img = [UIImage imageNamed:@"微博同步背景2.png"];
//        big.image = [img stretchableImageWithLeftCapWidth:15 topCapHeight:15];
//        [self.view insertSubview:big aboveSubview:backImageView];
//        [big release];
//    }
    
	UIBarButtonItem * barButton= [[UIBarButtonItem alloc]
								   initWithTitle:@"发送"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(handleSendContent:)];
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
	self.title = @"微博分享";
	if (shareImage == nil) {
		[imageButton removeFromSuperview];
		[selectButton removeFromSuperview];
		[sendLabel removeFromSuperview];
	}
       
	
	// 键盘高度变化通知，ios5.0新增的  
#ifdef __IPHONE_5_0
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
#else
	//注册坚挺系统键盘事件通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#endif
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
	self.defaultContent = nil;
	self.shareImage = nil;
	self.sinaAccessToken = nil;
	self.engine = nil;
	self.qAccessToken = nil;
	self.qOpenid = nil;
	self.qWeiboUserName = nil;
	self.progressHUD = nil;
	self.connection = nil;
	self.sendLabel = nil;
    self.backImageView = nil;
	self.sendButton = nil;
	self.textViewBackImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.defaultContent = nil;
	self.shareImage = nil;
	self.sinaAccessToken = nil;
	self.engine = nil; 
	self.qAccessToken = nil;
	self.qOpenid = nil;
	self.qWeiboUserName = nil;
	self.connection = nil;
	self.progressHUD = nil;
	self.sendLabel = nil;
    self.backImageView = nil;
	self.sendButton = nil;
	self.textViewBackImageView = nil;
    [sinaWeibo release],sinaWeibo = nil;
    [super dealloc];
}

-(IBAction) buttonPress:(id)sender{
	NSLog(@"button press");
	checkBoxSelected = !checkBoxSelected;
    if (checkBoxSelected == NO){
        [selectButton setImage:[UIImage imageNamed:@"选择1.png"] forState:UIControlStateNormal];
		[imageButton setImage:nil forState:UIControlStateNormal];
	}
    else{
        [selectButton setImage:[UIImage imageNamed:@"选择2.png"] forState:UIControlStateNormal];
		[imageButton setImage:shareImage forState:UIControlStateNormal];
	}
}

-(void) handleSendContent:(id)sender{
	NSUInteger length = [self unicodeLengthOfString :myTextView.text];
	NSLog(@"myTextView length:%lu",(unsigned long)length);
	if ([myTextView.text length] < 140) {
		[imageButton setUserInteractionEnabled:NO];
		[selectButton setUserInteractionEnabled:NO];
		
		engine.delegate = self;
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:backImageView];
		self.progressHUD = progressHUDTmp;
		[progressHUDTmp release];
		
		self.progressHUD.delegate = self;
		self.progressHUD.labelText = @"微博发送中";
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
		
		if (weiBoType == 0) {//分享至新浪微博
			if (checkBoxSelected == YES) {//同步分享图片
				//[engine sendWeiBoWithText:myTextView.text image:shareImage];
                [sinaWeibo requestWithURL:@"statuses/upload.json"
                                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           myTextView.text, @"status",
                                           shareImage, @"pic", nil]
                               httpMethod:@"POST"
                                 delegate:self];
			}else {//不同步分享图片
				//授权完成，调用微博接口获取新浪微博用户资料数据
				//[engine sendWeiBoWithText:myTextView.text image:nil];
                [sinaWeibo requestWithURL:@"statuses/update.json"
                                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:myTextView.text, @"status", nil]
                               httpMethod:@"POST"
                                 delegate:self];
			}		
		}else {
			
			//用GCD进行异步操作
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
				
				OpenApi *openApi = [[OpenApi alloc] initForApi:[OpenSdkBase getAppKey]
													 appSecret:[OpenSdkBase getAppSecret] 
												   accessToken:qAccessToken
												  accessSecret:nil
														openid:qOpenid oauthType:oauthMode];
				openApi.delegate = self;
				if (checkBoxSelected == YES) {//同步分享图片
					//发表带图片微博
					NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"temp.png"];
					[UIImagePNGRepresentation(shareImage) writeToFile:filePath atomically:YES];
					//发表带图片微博
					[openApi publishWeiboWithImage:filePath 
									  weiboContent:myTextView.text 
											  jing:@"" wei:@"" 
											format:@"json" clientip:[OpenSdkBase getClientIp] syncflag:@"1"];  
				}else {//不同步分享图片
					[openApi publishWeibo:myTextView.text jing:@""
									  wei:@"" format:@"json" 
								 clientip:[OpenSdkBase getClientIp] syncflag:@"0"]; //发表微博
				}
				[self performSelectorOnMainThread:@selector(publishQWeiboSuccess) withObject:nil waitUntilDone:YES];
			}); 
		}
	}else {
		[alertView showAlert:@"内容不能超过140个字"];
	}

}

#pragma mark - WBEngine Methods

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
	[alertView showAlert:@"分享失败，不要重复分享同一内容"];
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
	NSDictionary *dic = (NSDictionary*)result;
	NSString *idstr = [dic objectForKey:@"idstr"];
	NSLog(@"%@",idstr);
	[progressHUD setLabelText:@"内容已经分享到微博"];
	[progressHUD hide:YES afterDelay:3.0f];
}

#pragma mark -

#pragma mark MBProgressHUD
- (void)hudWasHidden:(MBProgressHUD *)hud{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/update.json"] || [request.url hasSuffix:@"statuses/upload.json"])
    {
        [progressHUD setLabelText:@"内容已经分享到微博"];
        progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
        progressHUD.mode = MBProgressHUDModeCustomView;
        [progressHUD hide:YES afterDelay:1.0f];
    }
}

- (void) publishQWeiboSuccess {
	isStillSending = NO;
	[progressHUD setLabelText:@"内容已经分享到微博"];
	[progressHUD hide:YES afterDelay:3.0f];
	self.connection = nil;
}

- (void)connection:publishQWeiboFail {
	[alertView showAlert:@"分享失败"];
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

#pragma mark TextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSLog(@"%@",textView.text);
	NSLog(@"text length:%d",[textView.text length]);
	NSLog(@"range location:%d",range.location);
	if ([textView.text length] < 140) {
		return YES;
	}
	if([text length] == 0) //点击了删除键  
	{  
		return YES;
	}  
	return NO;
}

-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
	
    for (NSUInteger i = 0; i < text.length; i++) {
		
		
        unichar uc = [text characterAtIndex: i];
		
        asciiLength += isascii(uc) ? 1 : 2;
    }
	
    NSUInteger unicodeLength = asciiLength / 2;
	
    if(asciiLength % 2) {
        unicodeLength++;
    }
	
    return unicodeLength;
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification{
	/*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification{
	NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void)moveInputBarWithKeyboardHeight:(float)height withDuration:(NSTimeInterval)animationDuration{    
    float viewHeight = self.view.frame.size.height;
    float imageHeight = imageButton.frame.size.height;  
	NSLog(@"viewHeight:%f",viewHeight);
	NSLog(@"imageHeight:%f",imageHeight);	
	NSString *inputType = [[UITextInputMode currentInputMode] primaryLanguage]; 
	if(IOS_VERSION >= 5.0){
		if ([inputType isEqualToString:@"zh-Hans"]) {
			height = 252.0f;
		}else {
			height = 216.0f;
		}	
		[backImageView setFrame:CGRectMake(backImageView.frame.origin.x,backImageView.frame.origin.y, backImageView.frame.size.width, viewHeight - height + 40)];
		[imageButton setFrame:CGRectMake(imageButton.frame.origin.x,viewHeight - height - imageHeight, imageButton.frame.size.width, imageHeight)];
		[selectButton setFrame:CGRectMake(selectButton.frame.origin.x,viewHeight - height - imageHeight + 15, selectButton.frame.size.width, selectButton.frame.size.height)];
		[sendLabel setFrame:CGRectMake(sendLabel.frame.origin.x,viewHeight - height - imageHeight + 15, sendLabel.frame.size.width, sendLabel.frame.size.height)];
		[sendButton setFrame:CGRectMake(sendButton.frame.origin.x,viewHeight - height - imageHeight, sendButton.frame.size.width, sendButton.frame.size.height)];
		[textViewBackImageView setFrame:CGRectMake(textViewBackImageView.frame.origin.x,textViewBackImageView.frame.origin.y, textViewBackImageView.frame.size.width, viewHeight - height + 40 - imageHeight -30)];
		[myTextView setFrame:CGRectMake(myTextView.frame.origin.x,myTextView.frame.origin.y, myTextView.frame.size.width, viewHeight - height - imageHeight - 30)];
	}
}


@end
