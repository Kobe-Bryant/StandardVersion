//
//  manageActionSheet.h
//  AppStrom
//
//  Created by 掌商 on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol commandOperationDelegate
- (void)getChoosedIndex:(int)index;
@end

@interface manageActionSheet : NSObject {
	NSArray *arr_menu;
	id<commandOperationDelegate> manageDeleage;
}
@property(nonatomic,retain)NSArray *arr_menu;
@property(nonatomic,assign)id<commandOperationDelegate> manageDeleage;
-(id)initActionSheetWithStrings:(NSArray*)strArray;
-(void)showActionSheet:(id)sender;
@end
