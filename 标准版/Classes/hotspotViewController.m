//
//  hotsportViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "hotspotViewController.h"
#import "Common.h"
#import "SBJson.h"
#import "HotRecommended.h"
#import "browserViewController.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#define CELL_BEGIN 25
@implementation hotspotViewController
@synthesize hotspotlist;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize myNavigationController;
#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.backgroundColor = [UIColor clearColor];

    if (IOS_VERSION >= 7.0) {
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        vv.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = vv;
        [vv release];
    }
    
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[progressHUDTmp release];
	
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	[_refreshHeaderView refreshLastUpdatedDate];
}
-(void)accessService{
	//	NSLog(@"sns id %@",[Common getVersion:HOT_RECOMMENDED_ID]);
	NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:HOT_RECOMMENDED_ID],@"ver",[NSNumber numberWithInt:shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/hot/recommand.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:HOT_RECOMMENDED delegate:self];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}
-(void)update{
	[self.imageDic removeAllObjects];
	self.hotspotlist = (NSMutableArray *)[DBOperate queryData:T_HOT theColumn:nil theColumnValue:nil withAll:YES];
	// dufu add 2013.06.18
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:[[rgbDictionary objectForKey:moduleLineRed_KEY] floatValue]
                                                    green:[[rgbDictionary objectForKey:moduleLineGreen_KEY] floatValue]
                                                     blue:[[rgbDictionary objectForKey:moduleLineBlue_KEY] floatValue]
                                                    alpha:[[rgbDictionary objectForKey:moduleLineAlpha_KEY] floatValue]];
	[self.tableView reloadData];
	//[self doneLoadingTableViewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@" nidayede ");
	if (isHotFirstLoad) 
	{
		[self accessService];
		isHotFirstLoad = NO;
	}
	else 
	{
		[self update];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if ([hotspotlist count]==0) {
		return 0;
	}
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"hotspotlist count %d",[hotspotlist count]);
	//if ([hotspotlist count]==0) {
	//	return 0;
	//}
    return [hotspotlist count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
	NSString *piclink = [hot objectAtIndex:hot_pic];
	NSNumber *isread = [hot objectAtIndex:hot_isread];
	NSNumber *isrecommend = [hot objectAtIndex:hot_is_recommend];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中色.png"]] autorelease];
		UIImageView *news = [[UIImageView alloc]initWithFrame:CGRectMake(8, 25, 10, 10)];
		UIImage *img;
		if ([isread intValue] == 0) {
			if([isrecommend intValue] == 1){
				img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"推荐" ofType:@"png"]];
			}else {
				img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"有更新" ofType:@"png"]];
			}
		}else{
			img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"没有更新" ofType:@"png"]];
		}
		news.image = img;
		news.tag = 1000;
		[img release];
		[cell.contentView addSubview:news];
		[news release];
		UILabel *mtitle = [[UILabel alloc]initWithFrame:CGRectZero];
		mtitle.backgroundColor = [UIColor clearColor];
		mtitle.tag = 101;
		mtitle.font = [UIFont systemFontOfSize:16];
		mtitle.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		
		[cell.contentView addSubview:mtitle];
		[mtitle release];
		UILabel *detailtitle = [[UILabel alloc]initWithFrame:CGRectZero];
		detailtitle.backgroundColor = [UIColor clearColor];
		detailtitle.tag = 102;
		detailtitle.font = [UIFont systemFontOfSize:12];
		detailtitle.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		
		[cell.contentView addSubview:detailtitle];
		[detailtitle release];
		UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectZero];
		picView.tag = 103;
		[cell.contentView addSubview:picView];
		[picView release];
		cell.backgroundColor = [UIColor clearColor];
		
	}
	
	//if ([indexPath row]%2 == 1) {
	//	cell.contentView.backgroundColor = [UIColor colorWithRed:0.88671875 green:0.88671875 blue:0.88671875 alpha:1];
	//}
	//else {
	//	cell.contentView.backgroundColor = [UIColor whiteColor];
	//}
	
	NSLog(@"index %d",[indexPath row]);
	UILabel *mainTitle = (UILabel *)[cell.contentView viewWithTag:101];
	UILabel *detailTitle = (UILabel *)[cell.contentView viewWithTag:102];
	UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:103];
	
	if (piclink.length > 1) {
		mainTitle.frame = CGRectMake(CELL_BEGIN, 4, cell.frame.size.width-photoWith-CELL_BEGIN-8, 30);
		detailTitle.frame = CGRectMake(CELL_BEGIN, 35, cell.frame.size.width-photoWith-CELL_BEGIN-8, 20);
		picView.frame = CGRectMake(cell.frame.size.width-photoWith-8, 2, photoWith, photoHigh);
		UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:[indexPath row]]]fillSize:CGSizeMake(photoWith, photoHigh)];
		if (!cardIcon)
		{
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"热点占位图" ofType:@"png"]];
			picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
			[img release];
			if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
			{
				cardIcon = [self getPhoto:indexPath];
				if (cardIcon!=nil) {
					picView.image = [cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
				}
				else {
					NSString *photoURL = [self getPhotoURL:indexPath];
					NSLog(@"no card icon  %@",photoURL);
					[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
				}
			}
		}
		else
		{
			picView.image = cardIcon;
		}
		
	}
	else {
		mainTitle.frame = CGRectMake(CELL_BEGIN, 4, cell.frame.size.width-CELL_BEGIN, 30);
		detailTitle.frame = CGRectMake(CELL_BEGIN, 35, cell.frame.size.width-CELL_BEGIN, 20);
		picView.frame = CGRectZero;
	}
	mainTitle.text = [hot objectAtIndex:hot_title];
	detailTitle.text = [hot objectAtIndex:hot_desc];
	return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UIImageView *news = (UIImageView *)[cell.contentView viewWithTag:1000];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"没有更新" ofType:@"png"]];
	news.image = img;
	
	NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
	NSNumber *hotId = [hot objectAtIndex:hot_id];
	[DBOperate updateData:T_HOT tableColumn: @"isread" columnValue: @"1" conditionColumn:@"id" conditionColumnValue:hotId];
	
	browserViewController *browser = [[browserViewController alloc]init];
	browser.isHideToolbar = NO;
    browser.linkurl = [hot objectAtIndex:hot_url];
	browser.linktitle = [hot objectAtIndex:hot_pic_name];
	[self.navigationController pushViewController:browser animated:YES];
	NSLog(@"url %@",[hot objectAtIndex:hot_url]);
	
	[browser release];
}
////////////loadImagedelegate
-(UIImage*)getPhoto:(NSIndexPath *)indexPath{
	/*NSLog(@"getPhoto");
	 NSArray *one = [hotspotlist objectAtIndex:[indexPath row]];
	 NSString *picName = [one objectAtIndex:hot_pic_name];
	 if (picName.length > 1) {
	 return [FileManager getPhoto:picName];
	 }
	 else {*/
	//return nil;
	//}
    
    NSArray *one = [hotspotlist objectAtIndex:[indexPath row]];
    NSString *url = [one objectAtIndex:hot_pic];
    NSString *picName = [Common encodeBase64:(NSMutableData *)[url dataUsingEncoding: NSUTF8StringEncoding]];
    if (picName.length > 1) {
        return [FileManager getPhoto:picName];
    }else {
        return nil;
    }
}
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath{
	NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
	return [hot objectAtIndex:hot_pic];
}
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath{
	NSLog(@"savePhoto");
	//NSString *photoname = [callSystemApp getCurrentTime];
    NSArray *one = [hotspotlist objectAtIndex:[indexPath row]];
    NSString *url = [one objectAtIndex:hot_pic];
    NSString *photoname = [Common encodeBase64:(NSMutableData *)[url dataUsingEncoding: NSUTF8StringEncoding]];
    if ([FileManager savePhoto:photoname withImage:photo]) {
        return YES;
    }else {
        return nil;
    }
}

- (void)loadImagesForOnscreenRows
{
	NSLog(@"load images for on screen");
    //if ([self.entries count] > 0)
    //{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		//GroupInfo *cardRecord = [self.entries objectAtIndex:indexPath.row];
		UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:indexPath.row]]scaleToSize:CGSizeMake(photoWith, photoHigh)];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:103];
		if (!cardIcon) // avoid the app icon download if the app already has an icon
		{
			////////////获取本地图片缓存
			if (loadImageDelegate != nil) {
				NSLog(@"load image delegate != nil or not1");
				cardIcon = [[loadImageDelegate getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
			}
			
			if (cardIcon == nil) {
				if (loadImageDelegate != nil) {
					NSLog(@"load image delegate != nil or not2");
					UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"热点占位图" ofType:@"png"]];
					picView.image = [img scaleToSize:CGSizeMake(photoWith, photoHigh)];
					[img release];
					NSString *photoURL = [loadImageDelegate getPhotoURL:indexPath];
					[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
				}
				
			}
			else {
				
				picView.image = cardIcon;
				[imageDic setObject:cardIcon forKey:[NSNumber numberWithInt:indexPath.row]];
			}
		}
		else {
			picView.image = cardIcon;
		}
		
	}
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:103];
        // Display the newly loaded image
		NSLog(@"card icon %f",iconDownloader.cardIcon.size.width);
		if(iconDownloader.cardIcon.size.width>2.0){ 
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
			if (loadImageDelegate != nil) {
				[loadImageDelegate savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
			}
			picView.image = photo;
			[self.tableView reloadData];
			[imageDic setObject:photo forKey:[NSNumber numberWithInt:[indexPath row]]];
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		NSLog(@"after remove object");
		if ([imageDownloadsInWaiting count]>1) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self loadPhoneNewsData:CMD_GET_PHONE_NEWS_LIST_REQ];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	[self accessService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"hotspotview controller unload");
	self.progressHUD = nil;
	self.hotspotlist = nil;
	commandOper.delegate = nil;
	self.commandOper = nil;
	_refreshHeaderView = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.commandOper = nil;
	self.hotspotlist = nil;
	self.progressHUD = nil;
	self.myNavigationController = nil;
	_refreshHeaderView = nil;
    [super dealloc];
}


@end

