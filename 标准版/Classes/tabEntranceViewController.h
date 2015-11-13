//
//  tabEntranceViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "manageActionSheet.h"
#import "serviceViewController.h"
#import "communityViewController.h"
#import "beautyPicViewController.h"

@class hotspotViewController;
@class moreViewController;
@class promotionsViewController;
@class companyNewsViewController;

@interface tabEntranceViewController : UITabBarController <UIAlertViewDelegate> {

	UIBarButtonItem *contactSegment;
	UISegmentedControl *productSegment;
	UIBarButtonItem *serviceBto1;
	UIBarButtonItem *serviceBto2;
	UIBarButtonItem *communityBto1;
	UIBarButtonItem *communityBto2;
	UISegmentedControl *hotspotSegment;
	UIBarButtonItem *moreBto;
	UIViewController *chooseVC;
	serviceViewController *service;
	communityViewController *community;
	UIBarButtonItem * tButtonItem;
	beautyPicViewController *beautyPic;
	hotspotViewController *hotspotView;
	promotionsViewController *promotionViewController;
	companyNewsViewController *companyNewsView;
	moreViewController *moreView;
	UIImageView *backview;
	
}
@property(nonatomic,retain)beautyPicViewController *beautyPic;
@property(nonatomic,retain)hotspotViewController *hotspotView;
@property(nonatomic,retain)promotionsViewController *promotionViewController;
@property(nonatomic,retain)companyNewsViewController *companyNewsView;
@property(nonatomic,retain)moreViewController *moreView;
@property(nonatomic,retain)UIBarButtonItem * ButtonItem;
@property(nonatomic,retain)UIBarButtonItem *contactSegment;
@property(nonatomic,retain)UISegmentedControl *productSegment;
@property(nonatomic,retain)UIBarButtonItem *serviceBto1;
@property(nonatomic,retain)UIBarButtonItem *serviceBto2;
@property(nonatomic,retain)UIBarButtonItem *communityBto1;
@property(nonatomic,retain)UIBarButtonItem *communityBto2;
@property(nonatomic,retain)UISegmentedControl *hotspotSegment;
@property(nonatomic,retain)UIBarButtonItem *moreBto;
@property(nonatomic,retain)UIViewController *chooseVC;
@property(nonatomic,retain)serviceViewController *service;
@property(nonatomic,retain)communityViewController *community;
@property(nonatomic,retain)UIImageView *backview;
@end
