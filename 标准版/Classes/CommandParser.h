//
//  parserCommand.h
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommandParser : NSObject {

}
+(NSMutableArray*)parseHotRecommended:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parsePromotions:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parseCompanyNews:(NSString*)jsonResul getVersion:(int*)ver;
+(NSMutableArray*)parseService:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parseSNS:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parseAboutus:(NSString*)jsonResult getVersion:(int*)ver;
+(NSDictionary*)parseProducts:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parseWallPaper:(NSString*)jsonResult getVersion:(int*)ver;
+(NSMutableArray*)parseApns:(NSString*)jsonResult getVersion:(int*)ver;
@end
