//
//  moreViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "aboutUsBody.h"

@interface moreViewController : UITableViewController <MBProgressHUDDelegate,commandOperationDelegate,UIAlertViewDelegate>{

	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	NSMutableArray *morelist;
	NSMutableArray *branchArray;
	aboutUsBody *abody;
}
@property(nonatomic,retain)NSMutableArray *branchArray;
@property(nonatomic,retain)aboutUsBody *abody;
@property(nonatomic,retain)NSMutableArray *morelist;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@end
