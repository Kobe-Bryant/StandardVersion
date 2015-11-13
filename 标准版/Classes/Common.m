//
//  Common.m
//  realmStatus
//
//  Created by zhang hao on 11-7-21.
//  Copyright 2011 SEL. All rights reserved.
//

#import "Common.h"
#import "SBJson.h"
#import "DBOperate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>

#import "base64.h"
#import <CommonCrypto/CommonCryptor.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netdb.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import <CoreLocation/CLLocationManager.h>
#import "SvUDIDTools.h"


@implementation Common
+(BOOL)connectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
    return (isReachable && !needsConnection) ? YES : NO;
}

+(void)testJson{

	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: 0],@"ver",[NSNumber numberWithInt: 1211],@"shop-id",[NSNumber numberWithInt: 1210],@"site-id",nil];
	SBJsonWriter *writer = [[SBJsonWriter alloc]init];
	NSString *jsonConvertedObj = [writer stringWithObject:jsontestDic];
	NSLog(@"the json converted object ... %@", jsonConvertedObj);
    [writer release];
	NSString *b64 = [self encodeBase64:[jsonConvertedObj dataUsingEncoding: NSUTF8StringEncoding]];
	NSLog(@"base64 %@",b64);
	NSString *urlEncode = [self URLEncodedString:b64];
	//NSString *urlEncode = b64;
	NSLog(@"urlEncode %@",urlEncode);
	NSString *reqStr = [NSString stringWithFormat:@"http://192.168.1.156:8080/hot/recommand.do?param=%@",urlEncode];
	NSURL *url = [NSURL URLWithString:reqStr];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSURLResponse *response; 
	NSError *error = nil;
	NSData* dataReply = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	NSString *resultStr = [[NSString alloc]initWithData:dataReply encoding: NSUTF8StringEncoding];
	NSLog(@"resultStr %@",resultStr);
	NSDictionary *dic = [resultStr JSONValue];
	int ver = [[dic objectForKey:@"ver"]intValue];
	
	NSArray *infoArray = [dic objectForKey:@"infos"];
	NSDictionary *infoDic = [infoArray objectAtIndex:0];
	
	int Id = [[infoDic objectForKey:@"id"]intValue];
	NSString *title = [infoDic objectForKey:@"title"];
	NSString *desc = [infoDic objectForKey:@"desc"];
	NSString *pic = [infoDic objectForKey:@"pic"];
	NSString *url1 = [infoDic objectForKey:@"url"];
	
	BOOL status = [[infoDic objectForKey:@"status"]boolValue];
	NSLog(@"json parse resunt:ver %d, id %d,title %@,desc %@,pic %@,url %@,status %d",ver,Id,title,desc,pic,url1,status);
}
+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl{
	SBJsonWriter *writer = [[SBJsonWriter alloc]init];
	NSString *jsonConvertedObj = [writer stringWithObject:sourceDic];
    [writer release];
	NSString *b64 = [Common encodeBase64:[jsonConvertedObj dataUsingEncoding: NSUTF8StringEncoding]];
	NSString *urlEncode = [Common URLEncodedString:b64];
	NSString *reqStr = [NSString stringWithFormat:strurl,urlEncode];
	return reqStr;
}
+(NSString*)encodeBase64:(NSMutableData*)data{
	size_t outputDataSize = EstimateBas64EncodedDataSize([data length]);
	Byte outputData[outputDataSize];
	Base64EncodeData([data bytes], [data length], outputData,&outputDataSize, YES);
	NSData *theData = [[NSData alloc]initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
	NSString *stringValue1 = [[NSString alloc]initWithData:theData encoding:NSUTF8StringEncoding];
	NSLog(@"reqdata string base64 %@",stringValue1);
	[theData release];
	return [stringValue1 autorelease];
}
+ (NSString*)URLEncodedString:(NSString*)input  
{  
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                                                           (CFStringRef)input,  
                                                                           NULL,  
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),  
                                                                           kCFStringEncodingUTF8);  
    [result autorelease];  
    return result;  
}  
+ (NSString*)URLDecodedString:(NSString*)input  
{  
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,  
                                                                                           (CFStringRef)input,  
                                                                                           CFSTR(""),  
                                                                                           kCFStringEncodingUTF8);  
    [result autorelease];  
    return result;    
}  
+(NSNumber*)getVersion:(int)commandId{
	NSArray *ar_version = [DBOperate queryData:T_VERSION theColumn:@"id" theColumnValue:[NSNumber numberWithInt:commandId] withAll:NO];
	
	if ([ar_version count]>0) {
		NSArray *arr_version = [ar_version objectAtIndex:0];
		NSLog(@"arversion %@ count %d",arr_version,[arr_version count]);
		return [arr_version objectAtIndex:dataversion_ver];
	}
	else {
		return [NSNumber numberWithInt:0];
	}
}
/*+ (UINavigationBar *)createNavigationBarWithBackgroundImage:(UIImage *)backgroundImage title:(NSString *)title {
	
    UINavigationBar *customNavigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    UIImageView *navigationBarBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [customNavigationBar addSubview:navigationBarBackgroundImageView];
    UINavigationItem *navigationTitle = [[UINavigationItem alloc] initWithTitle:title];
    [customNavigationBar pushNavigationItem:navigationTitle animated:NO];
    [navigationTitle release];
    [navigationBarBackgroundImageView release];
    return customNavigationBar;
}*/
@end
