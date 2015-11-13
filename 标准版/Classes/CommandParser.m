//
//  parserCommand.m
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandParser.h"
#import "SBJson.h"
#import "HotRecommended.h"
#import "Promotions.h"
#import "CompanyNews.h"
#import "serviceBranch.h"
#import "serviceHotLine.h"
#import "sns.h"
#import "aboutUsBody.h"
#import "aboutUsBranch.h"
#import "cats.h"
#import "product.h"
#import "productPic.h"
#import "wallpaper.h"
#import "businessPhone.h"
#import "DBOperate.h"
#import "Common.h"
@implementation CommandParser

+(bool)updateVersion:(int)commanId versionID:(NSNumber*)versionid desc:(NSString*)describe{
	if (versionid==nil) {
		return NO;
	}
	NSArray *ar_ver = [NSArray arrayWithObjects:[NSNumber numberWithInt:commanId],versionid,describe,nil];
	[DBOperate deleteData:T_VERSION tableColumn:@"id" columnValue:[NSNumber numberWithInt:commanId]];
	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_VERSION];
	return YES;
}


+(NSMutableArray*)parseHotRecommended:(NSString*)jsonResult getVersion:(int*)ver
{
	NSDictionary *dic = [jsonResult JSONValue];
	
	NSArray *infoArray = [dic objectForKey:@"infos"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_hot = [[NSMutableArray alloc]init];
			[ar_hot addObject:[infoDic objectForKey:@"id"]];
			[ar_hot addObject:[infoDic objectForKey:@"type"]];
			[ar_hot addObject:[infoDic objectForKey:@"title"]];
			[ar_hot addObject:[infoDic objectForKey:@"desc"]];
			[ar_hot addObject:[infoDic objectForKey:@"pic"]];
			[ar_hot addObject:@""];
			[ar_hot addObject:@""];
			[ar_hot addObject:[infoDic objectForKey:@"url"]];
			[ar_hot addObject:@"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_hot addObject:@"1"];
			}else {
				[ar_hot addObject:@"0"];
			}
			[ar_hot addObject:[infoDic objectForKey:@"created"]];
			//[DBOperate insertData:ar_hot tableName:T_HOT];
			[DBOperate deleteData:T_HOT tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_hot tableName:T_HOT];

			[ar_hot release];
		}
		else {
			[DBOperate deleteData:T_HOT tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
		
	}
	[self updateVersion:HOT_RECOMMENDED_ID versionID:[dic objectForKey:@"ver"] desc:@""];

	return nil;
	
}


+(NSMutableArray*)parsePromotions:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *infoArray = [dic objectForKey:@"infos"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_promotion = [[NSMutableArray alloc]init];
			[ar_promotion addObject:[infoDic objectForKey:@"id"]];
			[ar_promotion addObject:[infoDic objectForKey:@"type"]];
			[ar_promotion addObject:[infoDic objectForKey:@"title"]];
			[ar_promotion addObject:[infoDic objectForKey:@"desc"]];
			[ar_promotion addObject:[infoDic objectForKey:@"pic"]];
			[ar_promotion addObject:@""];
			[ar_promotion addObject:@""];
			[ar_promotion addObject:[infoDic objectForKey:@"url"]];
			[ar_promotion addObject:@"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_promotion addObject:@"1"];
			}else {
				[ar_promotion addObject:@"0"];
			}
			[ar_promotion addObject:[infoDic objectForKey:@"created"]];
			//[DBOperate insertData:ar_promotion tableName:T_PROMOTIONS];
			[DBOperate deleteData:T_PROMOTIONS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_promotion tableName:T_PROMOTIONS];
			[ar_promotion release];
		}
		else {
			[DBOperate deleteData:T_PROMOTIONS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}

	}
	[self updateVersion:PROMOTIONS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}

+(NSMutableArray*)parseCompanyNews:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *infoArray = [dic objectForKey:@"infos"];
	//NSMutableArray *resultArray = [[NSMutableArray alloc]init];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_companynews = [[NSMutableArray alloc]init];
			[ar_companynews addObject:[infoDic objectForKey:@"id"]];
			[ar_companynews addObject:[infoDic objectForKey:@"type"]];
			[ar_companynews addObject:[infoDic objectForKey:@"title"]];
			[ar_companynews addObject:[infoDic objectForKey:@"desc"]];
			[ar_companynews addObject:[infoDic objectForKey:@"pic"]];
			[ar_companynews addObject:@""];
			[ar_companynews addObject:@""];
			[ar_companynews addObject:[infoDic objectForKey:@"url"]];
			[ar_companynews addObject : @"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_companynews addObject:@"1"];
			}else {
				[ar_companynews addObject:@"0"];
			}
			[ar_companynews addObject:[infoDic objectForKey:@"created"]];
			[DBOperate deleteData:T_COMPANYNEWS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_companynews tableName:T_COMPANYNEWS];
			[ar_companynews release];
		}
		else {
			[DBOperate deleteData:T_COMPANYNEWS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
	}
	[self updateVersion:COMPANY_NEWS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
	
}

+(NSMutableArray*)parseService:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;
	NSDictionary *businessDic = [dic objectForKey:@"business-phone"];
	if ([businessDic objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
		if ([[businessDic objectForKey:@"status"]boolValue]) {
			
			[DBOperate deleteALLData:T_BUSINESS];
			NSMutableArray *ar_business = [[NSMutableArray alloc]init];
			[ar_business addObject:[businessDic objectForKey:@"tel"]];
			[DBOperate insertData:ar_business tableName:T_BUSINESS];
			//[DBOperate insertDataWithnotAutoID:ar_business tableName:T_BUSINESS];
			[ar_business release];
			[self updateVersion:BUSINESS_ID versionID:[businessDic objectForKey:@"ver"] desc:@""];
		}
		
	}
	
	NSDictionary *hotline = [dic objectForKey:@"hotline"];

	if ([hotline objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
    	if ([[hotline objectForKey:@"status"]boolValue]) {
    		[DBOperate deleteALLData:T_HOTLINE];
    		NSMutableArray *ar_hotline = [[NSMutableArray alloc]init];
    		[ar_hotline addObject:[hotline objectForKey:@"tel"]];
    		[ar_hotline addObject:[hotline objectForKey:@"mail"]];
    		[ar_hotline addObject:[hotline objectForKey:@"desc"]];
    		[ar_hotline addObject:[hotline objectForKey:@"title"]];
			[DBOperate deleteALLData:T_HOTLINE];
    		[DBOperate insertData:ar_hotline tableName:T_HOTLINE];
    		[ar_hotline release];
		
    	}
    	else {
      		[DBOperate deleteALLData:T_HOTLINE];
    	}
	}
	[self updateVersion:HOTLINE_ID versionID:[hotline objectForKey:@"ver"] desc:@""];

	NSDictionary *branchDic = [dic objectForKey:@"branchs"];
	NSArray *infoArray = [branchDic objectForKey:@"branchs"];
	for (NSDictionary *infoDic in infoArray){
		*ver = NEED_UPDATE;
		if ([infoDic objectForKey:@"status"]!=nil) {
			if ([[infoDic objectForKey:@"status"]boolValue]) {
				NSMutableArray *ar_branch = [[NSMutableArray alloc]init];
				[ar_branch addObject:[infoDic objectForKey:@"id"]];
				[ar_branch addObject:[infoDic objectForKey:@"name"]];
				[ar_branch addObject:[infoDic objectForKey:@"tel"]];
				[ar_branch addObject:[infoDic objectForKey:@"mobile"]];
				[ar_branch addObject:[infoDic objectForKey:@"fax"]];
				[ar_branch addObject:[infoDic objectForKey:@"mail"]];
				[ar_branch addObject:[infoDic objectForKey:@"companyname"]];
				[ar_branch addObject:[infoDic objectForKey:@"addr"]];
				[ar_branch addObject:[infoDic objectForKey:@"location"]];
				[ar_branch addObject:[infoDic objectForKey:@"showmail"]];
				[ar_branch addObject:[infoDic objectForKey:@"showfax"]];
				[ar_branch addObject:[infoDic objectForKey:@"showtel"]];
				[ar_branch addObject:[infoDic objectForKey:@"showmobile"]];
				[ar_branch addObject:[infoDic objectForKey:@"showname"]];
				[ar_branch addObject:[infoDic objectForKey:@"showlocation"]];
				[ar_branch addObject:[infoDic objectForKey:@"showaddr"]];
				[ar_branch addObject:[infoDic objectForKey:@"showcompanyname"]];
				[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
				[DBOperate insertDataWithnotAutoID:ar_branch tableName:T_SUBBRANCH];

				NSLog(@"arbranch %@",ar_branch);
				//[DBOperate insertData:ar_branch tableName:T_SUBBRANCH];
				[ar_branch release];
				
			}
			else {
				[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			}

			
		}
	}
	[self updateVersion:BRANCH_ID versionID:[branchDic objectForKey:@"ver"] desc:@""];	

	return nil;
}

+(NSMutableArray*)parseSNS:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;

	NSArray *infoArray = [dic objectForKey:@"links"];
	for (NSDictionary *infoDic in infoArray){
		*ver = NEED_UPDATE;
		if ([[infoDic objectForKey:@"status"]boolValue]) {
		NSMutableArray *ar_community = [[NSMutableArray alloc]init];
		[ar_community addObject:[infoDic objectForKey:@"id"]];
		[ar_community addObject:[infoDic objectForKey:@"name"]];
		[ar_community addObject:[infoDic objectForKey:@"desc"]];
		[ar_community addObject:[infoDic objectForKey:@"url"]];
		[ar_community addObject:[infoDic objectForKey:@"pic"]];
		[ar_community addObject:@""];
		[ar_community addObject:@""];
		[DBOperate deleteData:T_COMMUNITY tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		[DBOperate insertDataWithnotAutoID:ar_community tableName:T_COMMUNITY];
		[ar_community release];
		}
		else {
			[DBOperate deleteData:T_COMMUNITY tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}

	}
	[self updateVersion:SNS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}

+(NSMutableArray*)parseAboutus:(NSString*)jsonResult getVersion:(int*)ver{

	NSDictionary *dic = [jsonResult JSONValue];
	NSDictionary *bodyDic = [dic objectForKey:@"body"];
	
	*ver = NO_UPDATE;
	if ([bodyDic objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
    	if ([[bodyDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_about = [[NSMutableArray alloc]init];
    		[ar_about addObject:[bodyDic objectForKey:@"id"]];
    		[ar_about addObject:[bodyDic objectForKey:@"content"]];
    		[ar_about addObject:[bodyDic objectForKey:@"logo"]];
    		[ar_about addObject:@""];
    		[ar_about addObject:@""];
			//[DBOperate deleteData:T_ABOUT tableColumn:@"id" columnValue:[bodyDic objectForKey:@"id"]];
			[DBOperate deleteALLData:T_ABOUT];
    		[DBOperate insertDataWithnotAutoID:ar_about tableName:T_ABOUT];
	    	[ar_about release];
			[self updateVersion:ABOUTUS_ID versionID:[bodyDic objectForKey:@"ver"] desc:@""];

		
    	}
	else {
		[DBOperate deleteALLData:T_ABOUT];
		//[DBOperate deleteData:T_ABOUT tableColumn:@"id" columnValue:[bodyDic objectForKey:@"id"]];
    	}		
	}


	NSDictionary *branchDic = [dic objectForKey:@"branchs"];
	//*ver = [[branchDic objectForKey:@"ver"]intValue];

	NSArray *infoArray = [branchDic objectForKey:@"branchs"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_branch = [[NSMutableArray alloc]init];
			[ar_branch addObject:[infoDic objectForKey:@"id"]];
			[ar_branch addObject:[infoDic objectForKey:@"name"]];
			[ar_branch addObject:[infoDic objectForKey:@"tel"]];
			[ar_branch addObject:[infoDic objectForKey:@"mobile"]];
			[ar_branch addObject:[infoDic objectForKey:@"fax"]];
			[ar_branch addObject:[infoDic objectForKey:@"mail"]];
			[ar_branch addObject:[infoDic objectForKey:@"companyname"]];
			[ar_branch addObject:[infoDic objectForKey:@"addr"]];
			[ar_branch addObject:[infoDic objectForKey:@"location"]];
			[ar_branch addObject:[infoDic objectForKey:@"showmail"]];
			[ar_branch addObject:[infoDic objectForKey:@"showfax"]];
			[ar_branch addObject:[infoDic objectForKey:@"showtel"]];
			[ar_branch addObject:[infoDic objectForKey:@"showmobile"]];
			[ar_branch addObject:[infoDic objectForKey:@"showname"]];
			[ar_branch addObject:[infoDic objectForKey:@"showlocation"]];
			[ar_branch addObject:[infoDic objectForKey:@"showaddr"]];
			[ar_branch addObject:[infoDic objectForKey:@"showcompanyname"]];
			[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_branch tableName:T_SUBBRANCH];

			//[DBOperate insertData:ar_branch tableName:T_SUBBRANCH];
			[ar_branch release];
		}
		else {
			[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
	}
	[self updateVersion:BRANCH_ID versionID:[branchDic objectForKey:@"ver"] desc:@""];

	return nil;
}





+(NSDictionary*)parseProducts:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;
	NSArray *catsArray = [dic objectForKey:@"cats"];
	NSArray *productArray = [dic objectForKey:@"products"];
	for (NSDictionary *catsDic in catsArray) {
		*ver = NEED_UPDATE;
		if ([[catsDic objectForKey:@"status"]boolValue]) {
		NSMutableArray *ar_cat = [[NSMutableArray alloc]init];
		[ar_cat addObject:[catsDic objectForKey:@"id"]];
		[ar_cat addObject:[catsDic objectForKey:@"pid"]];
		[ar_cat addObject:[catsDic objectForKey:@"sortid"]];
		[ar_cat addObject:[catsDic objectForKey:@"name"]];
		[ar_cat addObject:[catsDic objectForKey:@"time"]];
		[ar_cat addObject:[catsDic objectForKey:@"pic"]];
		[ar_cat addObject:@""];
		[ar_cat addObject:@""];
		[ar_cat addObject:[catsDic objectForKey:@"product-id"]];//[ar_cat addObject:@" "];//
		[DBOperate deleteData:T_CATEGORY_PRETTY_PIC tableColumn:@"id" columnValue:[catsDic objectForKey:@"id"]];
		[DBOperate insertDataWithnotAutoID:ar_cat tableName:T_CATEGORY_PRETTY_PIC];
        //[DBOperate insertData:ar_cat tableName:T_CATEGORY_PRETTY_PIC];
		[ar_cat release];
		}
		else {
			[DBOperate deleteData:T_CATEGORY_PRETTY_PIC tableColumn:@"id" columnValue:[catsDic objectForKey:@"id"]];
		}

	}
	for (NSDictionary *productDic in productArray) {
		if ([[productDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_prod = [[NSMutableArray alloc]init];
			[ar_prod addObject:[productDic objectForKey:@"id"]];
			[ar_prod addObject:[productDic objectForKey:@"catid"]];
			[ar_prod addObject:[productDic objectForKey:@"name"]];
			[ar_prod addObject:[productDic objectForKey:@"desc"]];
			//[ar_prod addObject:[productDic objectForKey:@"time"]];
			[ar_prod addObject:[productDic objectForKey:@"url"]];
			
			[ar_prod addObject:[productDic objectForKey:@"pic"]];
			[ar_prod addObject:@""];
			[ar_prod addObject:@""];
			[ar_prod addObject:[productDic objectForKey:@"created"]];
			[DBOperate deleteData:T_PIC tableColumn:@"pid" columnValue:[productDic objectForKey:@"id"]];

			NSArray *picArray = [productDic objectForKey:@"pics"];
			for (NSDictionary *picDic in picArray) {
				NSMutableArray *ar_pic = [[NSMutableArray alloc]init];
				[ar_pic addObject:[productDic objectForKey:@"id"]];
				[ar_pic addObject:[picDic objectForKey:@"pic1"]];
				[ar_pic addObject:@""];
				[ar_pic addObject:@""];
				[ar_pic addObject:[picDic objectForKey:@"pic2"]];
				[ar_pic addObject:@""];
				[ar_pic addObject:@""];
				[DBOperate insertData:ar_pic tableName:T_PIC];
				[ar_pic release];
			}
			[DBOperate deleteData:T_PRODUCT_PRETTY_PIC tableColumn:@"id" columnValue:[productDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_prod tableName:T_PRODUCT_PRETTY_PIC];
			[ar_prod release];
		}
		else {
			[DBOperate deleteData:T_PIC tableColumn:@"pid" columnValue:[productDic objectForKey:@"id"]];
			[DBOperate deleteData:T_PRODUCT_PRETTY_PIC tableColumn:@"id" columnValue:[productDic objectForKey:@"id"]];
		}

	}
	[self updateVersion:PRODUCT_ID versionID:[dic objectForKey:@"ver"] desc:@""];

		return nil;
}

+(NSMutableArray*)parseWallPaper:(NSString*)jsonResult getVersion:(int*)ver
{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *picsArray = [dic objectForKey:@"pics"];
	for (NSDictionary *picDic in picsArray){
		if ([[picDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
			[ar_wp addObject:[picDic objectForKey:@"id"]];
			[ar_wp addObject:[picDic objectForKey:@"title"]];
			[ar_wp addObject:[picDic objectForKey:@"desc"]];
			[ar_wp addObject:[picDic objectForKey:@"pic"]];
			[ar_wp addObject:@""];
			[ar_wp addObject:[picDic objectForKey:@"pic2"]];
			[ar_wp addObject:@""];
			[ar_wp addObject:@""];
			[ar_wp addObject:@""];
			[DBOperate deleteData:T_WALLPAPER tableColumn:@"id" columnValue:[picDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WALLPAPER];
			[ar_wp release];
		}
		else{
			[DBOperate deleteData:T_WALLPAPER tableColumn:@"id" columnValue:[picDic objectForKey:@"id"]];
		}
	}
	[self updateVersion:WALLPAPER_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}

+(NSMutableArray*)parseApns:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	//int issuccess = [[dic objectForKey:@"isSuccess"]intValue];
	
	NSDictionary *appVerDic = [dic objectForKey:@"autopromotion"];		
	NSDictionary *appVerGradeDic = [dic objectForKey:@"grade"];
	
	if (appVerDic != [NSNull null]) {
		[DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:0]];
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[array addObject:[NSNumber numberWithInt:0]];
		[array addObject:[appVerDic objectForKey:@"ver_soft"]];
		[array addObject:[appVerDic objectForKey:@"url"]];
		[array addObject:[NSNumber numberWithInt:0]];
        [array addObject:[appVerDic objectForKey:@"remark"]];
		[DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
		[array release];
	}
	if (appVerGradeDic != [NSNull null]) {			
		[DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:1]];
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[array addObject:[NSNumber numberWithInt:1]];
		[array addObject:[appVerGradeDic objectForKey:@"ver_grade"]];
		[array addObject:[appVerGradeDic objectForKey:@"url"]];
		[array addObject:[NSNumber numberWithInt:0]];
        [array addObject:@""];
		[DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
	}
    return nil;
}
@end
