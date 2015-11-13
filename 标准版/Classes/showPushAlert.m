//
//  showPushAlert.m
//  AppStrom
//
//  Created by 掌商 on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "showPushAlert.h"
#import "browserViewController.h"

@implementation showPushAlert
@synthesize pushurl;
@synthesize theSuperViewController;
@synthesize alertV;
-(id)initWithContent:(NSString*)content onViewController:(UIViewController*)theViewController{

	if ([super init]!=nil) {
		self.theSuperViewController = theViewController;
		NSRange range = [content rangeOfString:@"http"];
		UIAlertView *av = nil;
		if (range.location != NSNotFound) {
			int start = range.location;
			self.pushurl = [content substringFromIndex:start];
			NSString *showContent = [content substringToIndex:start];
			if (pushurl.length>1) {
				av = [[UIAlertView alloc] initWithTitle:nil message:showContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接",nil];
			}
		}
		else {
		
			av = [[UIAlertView alloc] initWithTitle:nil message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
		
		}
		self.alertV = av;
		[av release];
		
	}
	return self;
}

-(id)initWithTitle:(NSString*)title url:(NSString*)purl onViewController:(UIViewController*)theViewController
{
    if ([super init]!=nil)
    {
		self.theSuperViewController = theViewController;
		UIAlertView *av = nil;
        if (title.length > 1)
        {
            if (purl.length>1)
            {
                self.pushurl = purl;
                av = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接",nil];
            }
            else
            {
                av = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            }
        }
		self.alertV = av;
		[av release];
		
	}
	return self;
}

-(void)showAlert{
  
	[alertV show];
	
}
- (void) alertView:(UIAlertView *) alertView1 clickedButtonAtIndex: (int) index
{
	if(index != alertView1.cancelButtonIndex)
	{
		browserViewController *browser = [[browserViewController alloc]init];
		browser.isHideToolbar = NO;
        browser.linkurl = pushurl;
		[self.theSuperViewController pushViewController:browser animated:YES];

		[browser release];
		
	}
	//self.alertV = nil;
	//[alertView1 release];
}

-(void)dealloc{
	if (alertV != nil) {
		[alertV dismissWithClickedButtonIndex:0 animated:YES];
		self.alertV = nil;
	}
   
	self.theSuperViewController = nil;
	self.pushurl = nil;
	
	[super dealloc];
}
@end
