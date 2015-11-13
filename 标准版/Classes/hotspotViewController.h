//
//  hotsportViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "LoadImageTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
@interface hotspotViewController:LoadImageTableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate,commandOperationDelegate,MBProgressHUDDelegate> {
//@interface hotspotViewController:UITableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate> {

	CommandOperation *commandOper;
	NSMutableArray *hotspotlist;
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	MBProgressHUD *progressHUD;
	UINavigationController *myNavigationController;
}
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)NSMutableArray *hotspotlist;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)UINavigationController *myNavigationController;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
