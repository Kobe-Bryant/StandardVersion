//
//  showPushAlert.h
//  AppStrom
//
//  Created by 掌商 on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface showPushAlert : NSObject{
	NSString *pushurl;
	UIViewController *theSuperViewController;
	UIAlertView *alertV;
}
@property(nonatomic,retain)UIAlertView *alertV;
@property(nonatomic,retain)UIViewController *theSuperViewController;
@property(nonatomic,retain)NSString *pushurl;
-(void)showAlert;
-(id)initWithContent:(NSString*)content onViewController:(UIViewController*)theViewController;
-(id)initWithTitle:(NSString*)title url:(NSString*)purl onViewController:(UIViewController*)theViewController;
@end
