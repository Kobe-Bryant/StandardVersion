/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  XMLParser.m
//  Created by Erica Sadun on 4/6/09.
//

#import "XMLParser.h"
#import "Common.h"
#import "ModuleObject.h"
#import "VideoObject.h"

@implementation XMLParser

@synthesize m_strCurrentElement;
@synthesize tabArray;
@synthesize moduelArrar;
@synthesize hotTabArrar;
@synthesize urlDictionary;
@synthesize morelistDictionary; // dufu add 2013.06.17
@synthesize rgbDictionary; // dufu add 2013.06.18
@synthesize videoArray;
@synthesize solidArray;
@synthesize shopId;
@synthesize siteId;
@synthesize shopName;
@synthesize isShowNavBg;
@synthesize red_color;
@synthesize green_color;
@synthesize blue_color;
@synthesize font_red_color;
@synthesize font_green_color;
@synthesize font_blue_color;
//@synthesize sinaAppkey; 
//@synthesize sinaAppSecret; 
//@synthesize redirectUrl; 
//@synthesize qqAppkey; 
//@synthesize qqAppSecret; 

static XMLParser *sharedInstance = nil;

// Use just one parser instance at any time
+(XMLParser *) sharedInstance 
{
    if(!sharedInstance) {
		sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}


- (void *)parseXMLFromURL: (NSURL *) url
{	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[pool drain];
}

- (void *)parseXMLFromData: (NSData *) data
{	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
    [parser release];
}

- (void) parserXMLFromFile:(NSString*) xmlFilePath{
	NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:xmlFilePath];
	[inputStream open];
	//read file 
	NSInteger maxLength = 1024 * 256;
	uint8_t readBuffer [maxLength];
	BOOL endOfStreamReached = NO;
	while (!endOfStreamReached) {
		NSInteger byteRead = [inputStream read:readBuffer maxLength:maxLength];
		if(byteRead == 0){
			endOfStreamReached = YES;
		}else if (byteRead == -1) {//error
			endOfStreamReached = YES;
		}else {
			NSString *readBufferString = [[NSString alloc] initWithBytesNoCopy:readBuffer length:byteRead encoding:NSUTF8StringEncoding freeWhenDone:NO];
			//NSLog(readBufferString);
			NSData *xmlData = [readBufferString dataUsingEncoding:NSUTF8StringEncoding];
			[self parseXMLFromData : xmlData];
			[readBufferString release];
		}
		
	}
	[inputStream release];
}


// Descend to a new element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	NSLog(elementName);
	// 纪录当前解析的节点 
	m_strCurrentElement = elementName; 
	ModuleObject *mb = [[ModuleObject alloc] init];
	if([elementName isEqualToString:@"app"]){
		NSMutableArray *tArray = [[NSMutableArray alloc] init];
		self.tabArray = tArray;
		NSMutableArray *mArray = [[NSMutableArray alloc] init];
		self.moduelArrar = mArray;
		NSMutableArray *hArray = [[NSMutableArray alloc] init];
		self.hotTabArrar = hArray;
		NSMutableDictionary *urlDic = [[NSMutableDictionary alloc] init];
		self.urlDictionary = urlDic;
        
        // dufu add 2013.06.17
        NSMutableDictionary *morelistDic = [[NSMutableDictionary alloc] init];
		self.morelistDictionary = morelistDic;
        // dufu add 2013.06.18
        NSMutableDictionary *rgbDic = [[NSMutableDictionary alloc] init];
		self.rgbDictionary = rgbDic;
        
		NSMutableArray *vArray = [[NSMutableArray alloc] init];
		self.videoArray = vArray;
		NSMutableArray *sArray = [[NSMutableArray alloc] init];
		self.solidArray = sArray;
		NSString *sname = [[NSString alloc] init];
		self.shopName = sname;
		[sname release];
		[tArray release];
		[mArray release];
		[hArray release];
		[urlDic release];
		[vArray release];
	}else if([elementName isEqualToString:@"tabItem"]){
		mb.status = [attributeDict valueForKey:@"status"];
		mb.name = [attributeDict valueForKey:@"lable"];
		mb.key = [attributeDict valueForKey:@"name"];
		[tabArray addObject : mb];
	}else if ([elementName isEqualToString:@"module"]) {
		mb.status = [attributeDict valueForKey:@"status"];
		mb.key = [attributeDict valueForKey:@"name"];
		mb.name = [attributeDict valueForKey:@"lable"];
		[moduelArrar addObject : mb];
	}else if ([elementName isEqualToString:@"hotTab"]) {
		mb.status = [attributeDict valueForKey:@"status"];
		mb.name = [attributeDict valueForKey:@"value"];
		mb.key = [attributeDict valueForKey:@"name"];
		[hotTabArrar addObject : mb];
	}else if ([elementName isEqualToString:@"url"] || [elementName isEqualToString:@"string"]) {
		NSString *key = [attributeDict valueForKey:@"name"];
		NSString *value = [attributeDict valueForKey:@"value"];
		[urlDictionary setObject: value forKey: key];
 	}else if ([elementName isEqualToString:@"video"] ) {
		if([[attributeDict valueForKey:@"status"] isEqualToString:@"1"]){
			VideoObject *vo = [[VideoObject alloc] init];
			NSString *isLocal = [attributeDict valueForKey:@"isLocal"];	
			NSString *path = [attributeDict valueForKey:@"path"];
			NSString *value = [attributeDict valueForKey:@"value"];
			NSString *desc = [attributeDict valueForKey:@"desc"];
			NSString *pic = [attributeDict valueForKey:@"pic"];
			NSString *videotype = [attributeDict valueForKey:@"videotype"];
			vo.isLocal = isLocal;
			vo.path = path;
			vo.name = value;
			vo.desc = desc;
			vo.pic = pic;
			vo.videotype = videotype;
			[videoArray addObject:vo];
		}
	}else if ([elementName isEqualToString:@"infoItem"]) {
		if([[attributeDict valueForKey:@"name"] isEqualToString:@"shopId"]){
			shopId = [[attributeDict valueForKey:@"value"] intValue];
			shopName = [attributeDict valueForKey:@"shopName"];
		}else if ([[attributeDict valueForKey:@"name"] isEqualToString:@"siteId"]) {
			siteId = [[attributeDict valueForKey:@"value"] intValue];
		}
	}else if ([elementName isEqualToString:@"showNavBg"]) {
		if([[attributeDict valueForKey:@"value"] isEqualToString:@"1"]){
			isShowNavBg = YES;
		}else{
			isShowNavBg = NO;
		}
	}else if ([elementName isEqualToString:@"color"]) {
		if([[attributeDict valueForKey:@"name"] isEqualToString:@"red"]){
			red_color = [[attributeDict valueForKey:@"value"] floatValue];
		}else if ([[attributeDict valueForKey:@"name"] isEqualToString:@"green"]) {
			green_color = [[attributeDict valueForKey:@"value"] floatValue];
		}else if ([[attributeDict valueForKey:@"name"] isEqualToString:@"blue"]) {
			blue_color = [[attributeDict valueForKey:@"value"] floatValue];
		} else if([[attributeDict valueForKey:@"name"] isEqualToString:@"font_red"]){
			font_red_color = [[attributeDict valueForKey:@"value"] floatValue];
		}else if([[attributeDict valueForKey:@"name"] isEqualToString:@"font_green"]){
			font_green_color = [[attributeDict valueForKey:@"value"] floatValue];
		}else if([[attributeDict valueForKey:@"name"] isEqualToString:@"font_blue"]){
			font_blue_color = [[attributeDict valueForKey:@"value"] floatValue];
		}
	}else if ([elementName isEqualToString:@"solid"]){
		mb.name = [attributeDict valueForKey:@"picName"];
		mb.key = [attributeDict valueForKey:@"picType"];
		mb.num = [[attributeDict valueForKey:@"picCount"] intValue];
		[solidArray addObject:mb];
	}else if ([elementName isEqualToString:@"weiboType"]) {
		if([[attributeDict valueForKey:@"name"] isEqualToString:@"sina"]){
//			NSString *key = [[NSString alloc] init];
//			key = [attributeDict valueForKey:@"appKey"];
//			self.sinaAppkey = key;
//			[key release];
//			NSString *secret = [[NSString alloc] init];
//			secret = [attributeDict valueForKey:@"appSecret"];
//			self.sinaAppSecret = secret;
//			[secret release];
//			NSString *url = [[NSString alloc] init];
//			url = [attributeDict valueForKey:@"redirectUrl"];
//			self.redirectUrl = url;
//			[url release];
		}else if ([[attributeDict valueForKey:@"name"] isEqualToString:@"tencent"]) {
//			NSString *key = [[NSString alloc] init];
//			key = [attributeDict valueForKey:@"appKey"];
//			self.qqAppkey = key;
//			[key release];
//			NSString *secret = [[NSString alloc] init];
//			secret = [attributeDict valueForKey:@"appSecret"];
//			self.qqAppSecret = secret;
//			[secret release];			
		} 
	} else if ([elementName isEqualToString:@"listName"] || [elementName isEqualToString:@"grade"]) { /*dufu add 2013.06.17*/
        NSString *key = [attributeDict valueForKey:@"name"];
        NSString *value = [attributeDict valueForKey:@"value"];
        [morelistDictionary setObject: value forKey: key];
    } else if ([elementName isEqualToString:@"videoLineColor"] || [elementName isEqualToString:@"moduleLineColor"]) { /*dufu add 2013.06.18*/
        NSString *key = [attributeDict valueForKey:@"name"];
        NSString *value = [attributeDict valueForKey:@"value"];
        [rgbDictionary setObject: value forKey: key];
    }
    
	[mb release];
}
// Pop after finishing element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
}

// Reached a leaf
//处理标签包含内容字符 （报告元素的所有或部分内容）
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	
}

- (void) dealloc{
	[videoArray release];
	[tabArray release];
	[moduelArrar release];
	[hotTabArrar release];
	[urlDictionary release];
    [morelistDictionary release];   // dufu add 2013.06.17
    [rgbDictionary release];      // dufu add 2013.06.18
	[shopName release];
	[videoArray release];
	[solidArray release];	
//	[sinaAppkey release];
//	[sinaAppSecret release];
//	[redirectUrl release];
//	[qqAppkey release];
//	[qqAppSecret release]; 
	[super dealloc];
}

@end



