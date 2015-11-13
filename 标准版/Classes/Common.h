//
//  Common.h
//  realmStatus
//
//  Created by zhang hao on 11-7-21.
//  Copyright 2011 SEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define dataBaseFile @"appstorm.db"
#define CONFIG_FILE_NAME @"config"
#define CONFIG_FILE_TYPE @"xml"
#define goup5String @""
///////////////////////接口id
#define HOT_RECOMMENDED 1
#define PROMOTIONS 2
#define COMPANY_NEWS 3
#define SERVICE 4
#define COMMUNITY 5
#define ABOUTUS 6
#define PRODUCT 7
#define WALLPAPER 8
#define APNS 9

#define HOT_RECOMMENDED_ID 1
#define PROMOTIONS_ID 2
#define COMPANY_NEWS_ID 3
#define BUSINESS_ID 4
#define HOTLINE_ID 5
#define BRANCH_ID 6
#define SNS_ID 7
#define ABOUTUS_ID 8
#define PRODUCT_ID 9
#define WALLPAPER_ID 10

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

int currentSelectingIndex;

////////////////////////全局变量
NSOperationQueue	*networkQueue;
NSMutableArray *netWorkQueueArray;
UIActivityIndicatorView *commonSpinner;
CLLocationCoordinate2D myLocation;

NSMutableArray		*tabArray;	//底部tab文字
NSMutableArray		*produceModuleArray;//产品模块
NSMutableArray		*hotTabArrar;
NSDictionary		*urlDictionary;
NSMutableArray		*videoListArray;
NSMutableArray		*soildListArray;
NSString			*ACCESS_SERVICE_LINK;
NSString			*SHARE_TO_SINA;
NSString			*SHARE_TO_QQ;
NSString			*App_Registration;
NSString			*Feedback;
NSString			*shop_link;
NSString			*SHARE_CONTENT;
NSString			*invite_content;
NSString			*emailSubject;
NSString			*emailContent;
int					shop_id;
NSString			*shop;
int					site_id;
float				BTO_COLOR_RED;
float				BTO_COLOR_GREEN;
float				BTO_COLOR_BLUE;
float				FONT_COLOR_RED;
float				FONT_COLOR_GREEN;
float			    FONT_COLOR_BLUE;
bool				isHotFirstLoad;
bool				isPromotionFirstLoad;
bool				isComNewsFirstLoad;
//NSString			*SinaAppKey;
//NSString			*SinaAppSecret;
//NSString			*QQAppKey;
//NSString			*QQAppSecret;
//NSString			*redirectUrl;

// dufu add 2013.06.17
NSDictionary		*morelistDictionary;
#define abountWe_KEY @"aboutWe"
#define goGrade_KEY @"goGrade"
#define goGradeTitle_KEY @"gradeTitle"
#define goGradeContent_KEY @"gradeContent"
// dufu add 2013.06.18
NSDictionary		*rgbDictionary;
#define videoLineRed_KEY @"lineRed"
#define videoLineGreen_KEY @"lineGreen"
#define videoLineBlue_KEY @"lineBlue"
#define videoLineAlpha_KEY @"lineAlpha"
#define moduleLineRed_KEY @"moduleRed"
#define moduleLineGreen_KEY @"moduleGreen"
#define moduleLineBlue_KEY @"moduleBlue"
#define moduleLineAlpha_KEY @"moduleAlpha"

#define SINA @"sina"
#define TENCENT @"tencent"
#define SinaAppKey @"198584703"
#define SinaAppSecret @"5e489534493f4bbc27e0da3c92bee0f3"
#define QQAppKey @"801106679"
#define QQAppSecret @"14e3e1188d69231e59f6c98d4a9a5527"
#define redirectUrl @"http://our.3g.yunlai.cn"


#define ACCESS_SERVICE_LINK_KEY @"accessLink"
#define SHARE_TO_SINA_KEY @"sinaUrl"
#define SHARE_TO_QQ_KEY @"tencentUrl"
#define App_Registration_KEY @"regLink"
#define Feedback_KEY @"feedback"
#define shop_link_KEY @"shopLink"
#define SHARE_CONTENT_KEY @"share"
#define invite_content_KEY @"invite"
#define emailSubject_KEY @"emailSubject"
#define emailContent_KEY @"emailContent"

//当前app版本
#define CURRENT_APP_VERSION 4

////////////////////////全局使用参数
/////////宏编译控制
#define IOS4 1
#define SHOW_NAV_TAB_BG 2
#define NAV_BG_PIC @"上bar.png"
#define TAB_BG_PIC @"下bar.png"
#define IOS7_NAV_BG_PIC @"ios7上bar.png"
#define BG_IMAGE @"背景.png"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#define EMAILMATCHSTRING @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"

#define MAXICONDOWNLOADINGNUM 3 //同时下载图片的数量

#define CUSTOMER_PHOTO 10000 // 下载图片类型

#define NEED_UPDATE 1
#define NO_UPDATE 0


CLLocationManager *locManager;
@interface Common : NSObject {
}
+(void)testJson;
+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl;
+(NSString*)encodeBase64:(NSMutableData*)data;
+(NSString*)URLEncodedString:(NSString*)input;
+(NSString*)URLDecodedString:(NSString*)input;
+(NSNumber*)getVersion:(int)commandId;
+(BOOL)connectedToNetwork;
@end
