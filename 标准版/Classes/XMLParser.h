/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  XMLParser.h
//  Created by Erica Sadun on 4/6/09.
//

#import <CoreFoundation/CoreFoundation.h>

@interface XMLParser : NSObject
{
	NSString			*m_strCurrentElement;  //读到的当前节点的名 
	NSMutableArray		*tabArray;
	NSMutableArray		*moduelArrar;
	NSMutableArray		*hotTabArrar;
	NSMutableDictionary	*urlDictionary;
    NSMutableDictionary	*morelistDictionary;    // dufu add 2013.06.17
    NSMutableDictionary	*rgbDictionary;       // dufu add 2013.06.18
	NSMutableArray		*videoArray;
	NSMutableArray		*solidArray;
	int					shopId;
	int					siteId;
	NSString			*shopName;
	BOOL				isShowNavBg;
	float				red_color;
	float				green_color;
	float				blue_color;
	float				font_red_color;
	float				font_green_color;
	float				font_blue_color;
//	NSString			*sinaAppkey;
//	NSString			*sinaAppSecret;
//	NSString			*redirectUrl;
//	NSString			*qqAppkey;
//	NSString			*qqAppSecret;
}

@property(nonatomic,retain) NSString			*m_strCurrentElement; 
@property(nonatomic,retain) NSMutableArray		*tabArray; 
@property(nonatomic,retain) NSMutableArray		*moduelArrar; 
@property(nonatomic,retain) NSMutableArray		*hotTabArrar; 
@property(nonatomic,retain) NSMutableDictionary *urlDictionary;
@property(nonatomic,retain) NSMutableDictionary	*morelistDictionary;    // dufu add 2013.06.17
@property(nonatomic,retain) NSMutableDictionary	*rgbDictionary;       // dufu add 2013.06.18
@property(nonatomic,retain) NSMutableArray		*videoArray;
@property(nonatomic,retain) NSMutableArray		*solidArray;
@property(nonatomic,retain) NSString			*shopName;
@property(nonatomic) int						shopId;
@property(nonatomic) int						 siteId;
@property(nonatomic) BOOL						 isShowNavBg;
@property(nonatomic) float						 red_color;
@property(nonatomic) float						 green_color;
@property(nonatomic) float						 blue_color;
@property(nonatomic) float						 font_red_color;
@property(nonatomic) float						 font_green_color;
@property(nonatomic) float						 font_blue_color;
//@property(nonatomic,retain) NSString			*sinaAppkey; 
//@property(nonatomic,retain) NSString			*sinaAppSecret; 
//@property(nonatomic,retain) NSString			*redirectUrl; 
//@property(nonatomic,retain) NSString			*qqAppkey; 
//@property(nonatomic,retain) NSString			*qqAppSecret; 

+(XMLParser *) sharedInstance;
- (void *) parseXMLFromURL: (NSURL *) url;
- (void *) parseXMLFromData: (NSData*) data;
- (void *) parserXMLFromFile:(NSString*) xmlFilePath;
- (void) dealloc;
@end

