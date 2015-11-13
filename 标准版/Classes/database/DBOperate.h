//
//  DBOperate.h
//  Shopping
//
//  Created by zhu zhu chao on 11-3-22.
//  Copyright 2011 sal. All rights reserved.
//

#import <Foundation/Foundation.h>
#define	WHOLE_COLUMN 0
#define T_VERSION @"t_version"
#define T_CATEGORY_PRETTY_PIC @"t_category_pretty_pic"
#define T_PRODUCT_PRETTY_PIC @"t_product_pretty_pic"
#define T_PIC @"t_pic"
#define T_WALLPAPER @"t_wallpaper"
#define T_COMMUNITY @"t_community"
#define T_HOT @"t_hot"
#define T_PROMOTIONS @"t_promotions"
#define T_COMPANYNEWS @"t_companynews"
#define T_HOTLINE @"t_hotline"
#define T_360PIC @"tb_360pic"
#define T_SUBBRANCH @"t_subbranch"
#define T_ABOUT @"t_about"
#define T_VIDEO @"tb_video"
#define T_BUSINESS @"t_business"
#define T_MYSERVICE @"t_myservice"
#define T_MYSNS @"t_mysns"
#define T_DEVTOKEN @"t_devtoken"
#define T_WEIBO_USERINFO @"t_weibo_userinfo"
#define T_APP_INFO @"t_app_info"

#define C_T_CATEGORY_PRETTY_PIC @"create table t_category_pretty_pic\
(id INTEGER PRIMARY KEY,\
pid INTEGER ,\
sortid INTEGER,\
name TEXT,\
time INTEGER ,\
pic_url TEXT,pic_path TEXT,pic_name TEXT,\
product_id INTEGER)"

enum category_pertty_pic {
	category_id,
	category_pid,
	category_sortid,
	category_name,
	category_time,
	category_pic_url,
	category_pic_path,
	category_pic_name,
	category_product_id
};

#define C_T_PRODUCT_PRETTY_PIC @"create table t_product_pretty_pic\
(id INTEGER PRIMARY KEY,catid INTEGER,\
name TEXT,desc TEXT,\
url TEXT,\
pic_url TEXT,pic_path TEXT,pic_name TEXT,createTime INTEGER)"
enum product_pretty_pic {
	product_id,
	product_catid,
	product_name,
	product_desc,
	product_url,
	product_pic_url,
	product_pic_path,
	product_pic_name,
	product_pic_create_time
};
#define C_T_WALLPAPER @"create table t_wallpaper \
(id INTEGER PRIMARY KEY,\
title TEXT,\
desc TEXT,\
pic_url TEXT,pic_path TEXT,\
thumb_pic_url TEXT,thumb_pic_path TEXT,\
pic_name TEXT,thumb_pic_name TEXT)"
enum p_wallpaper{
	wallpaper_id,
	wallpaper_title,
	wallpaper_desc,
	wallpaper_pic_url,
	wallpaper_pic_path,
	wallpaper_thumb_pic_url,
	wallpaper_thumb_pic_path,
	wallpaper_pic_name,
	wallpaper_thumb_pic_name
};
#define C_T_COMMUNITY @"create table t_community\
(id INTEGER PRIMARY KEY,\
name TEXT,desc TEXT,url TEXT,\
pic_url TEXT,pic_path TEXT,pic_name TEXT)"

enum community {
	community_id,
	community_name,
	community_desc,
	community_url,
	community_pic_url,
	community_pic_path,
	community_pic_name
};
#define C_T_HOT @"create table t_hot\
(id INTEGER PRIMARY KEY,type INTEGER,\
title TEXT,desc TEXT,\
pic TEXT,pic_path TEXT,pic_name TEXT,\
url TEXT,isread INTEGER,isRecommend INTEGER,createTime INTEGER)"
enum hot {
	hot_id,
	hot_type,
	hot_title,
	hot_desc,
	hot_pic,
	hot_pic_path,
	hot_pic_name,
	hot_url,
	hot_isread,
	hot_is_recommend,
	hot_create_time
};
#define C_T_PROMOTIONS @"create table t_promotions\
(id INTEGER PRIMARY KEY,type INTEGER,\
title TEXT,desc TEXT,\
pic TEXT,pic_path TEXT,pic_name TEXT,\
url TEXT,isread INTEGER,isRecommend INTEGER,createTime INTEGER)"
enum promotions {
	promotions_id,
	promotions_type,
	promotions_title,
	promotions_desc,
	promotions_pic,
	promotions_pic_path,
	promotions_pic_name,
	promotions_url,
	promotions_isread,
	promotions_is_recommend,
	promotions_create_time
};
#define C_T_COMPANYNEWS @"create table t_companynews\
(id INTEGER PRIMARY KEY,type INTEGER,\
title TEXT,desc TEXT,\
pic TEXT,pic_path TEXT,pic_name TEXT,\
url TEXT,isread INTEGER,isRecommend INTEGER,createTime INTEGER)"
enum companynews {
	companynews_id,
	companynews_type,
	companynews_title,
	companynews_desc,
	companynews_pic,
	companynews_pic_path,
	companynews_pic_name,
	companynews_url,
	companynews_isread,
	companynews_is_recommend,
	companynews_create_time
};
#define C_T_HOTLINE @"create table t_hotline(id integer primary key autoincrement,tel TEXT,mail TEXT,desc TEXT,title TEXT)"
enum hotline {
	hotline_id,
	hotline_tel,
	hotline_mail,
	hotline_desc,
	hotline_title
};

#define C_T_BUSINESS @"create table t_business(id integer primary key autoincrement,tel TEXT)"
enum business {
	business_id,
	business_tel
};
#define C_T_SUBBRANCH @"create table t_subbranch(\
id INTEGER PRIMARY KEY,name TEXT,\
tel TEXT,mobile TEXT,\
fax TEXT,mail TEXT,companyname TEXT,\
addr TEXT,location TEXT,\
showmail BOOLEAN,showfax BOOLEAN,showtel BOOLEAN,\
showmobile BOOLEAN,showname BOOLEAN,\
showlocation BOOLEAN,showaddr BOOLEAN,\
showcompanyname BOOLEAN)"
enum subbranch{
	subbranch_id,
	subbranch_name,
	subbranch_tel,
	subbranch_mobile,
	subbranch_fax,
	subbranch_mail,
	subbranch_companyname,
	subbranch_addr,
	subbranch_location,
	subbranch_showmail,
	subbranch_showfax,
	subbranch_showtel,
	subbranch_showmobile,
	subbranch_showname,
	subbranch_showlocation,
	subbranch_showaddr,
	subbranch_showcompanyname
};
#define C_T_ABOUT @"create table t_about (id INTEGER PRIMARY KEY,content TEXT,\
logo_url TEXT,logo_path TEXT,logo_name TEXT)"
enum aboutus {
	aboutus_id,
	aboutus_content,
	aboutus_logo_url,
	aboutus_logo_path,
	aboutus_logo_name,
};
#define C_T_PIC @"create table t_pic\
(id integer primary key autoincrement,\
pid INTEGER,\
pic1_url TEXT,pic1_path TEXT,pic1_name,\
pic2_url TEXT,pic2_path TEXT,pic2_name)"
enum originpic {
	originpic_id,
	originpic_pid,
	originpic_pic1_url,
	originpic_pic1_path,
	originpic_pic1_name,
	originpic_pic2_url,
	originpic_pic2_path,
	originpic_pic2_name
};

#define C_T_MYSERVICE @"create table t_myservice\
(id integer primary key autoincrement,cspic TEXT,csname TEXT,csphone TEXT,\
  csareacode TEXT,csmail TEXT,csaddress TEXT,cscoordinate TEXT)"
enum myservice {
	myservice_id,
	myservice_csPic,
	myservice_csName,
	myservice_csPhone,
	myservice_csAreaCode,
	myservice_csMail,
	myservice_csAddress,
	myservice_csAddCoordinate
};
#define C_T_MYSNS @"create table t_mysns\
(id integer primary key autoincrement,name TEXT,\
url TEXT,pic TEXT,explain TEXT)"
enum mysns {
	mysns_id,
	mysns_name,
	mysns_url,
	mysns_pic,
	mysns_explain
};
#define C_T_VERSION @"create table t_version\
(id INTEGER PRIMARY KEY,\
ver INTEGER,\
desc TEXT)"
enum dataversion {
	dataversion_id,
	dataversion_ver,
	dateversion_desc
};
#define C_T_DEVTOKEN @"create table t_devtoken\
(id INTEGER PRIMARY KEY,\
token DOUBLE)"
enum devtoken {
	devtoken_id,
	devtoken_token
};
#define C_T_WEIBO_USERINFO @"create table t_weibo_userinfo\
(weiboType TEXT,weiboUserId TEXT,weiboExpiresTime DOUBLE,oauthToken TEXT,oauthTokenSecret TEXT,\
accessToken TEXT,weiboUserName TEXT,oauthTime INTEGER,openId TEXT,openKey TEXT)"
enum weiboinfo {
	weibo_type,
	weibo_user_id,
	weibo_expires_time,
	weibo_oauth_token,
	weibo_oauth_token_secret,
	weibo_access_token,
	weibo_user_name,
	weibo_oauth_time,
	weibo_open_id,
	weibo_open_key
};

#define C_T_APP_INFO @"create table t_app_info\
(type INTEGER, ver_info INTEGER, url TEXT,remide INTEGER,remark TEXT)"
enum versioninfo {
	versioninfo_type,
	versioninfo_ver,
	versioninfo_url,
	versioninfo_remide,
    versioninfo_remark
};


@interface DBOperate : NSObject {

}
+(BOOL)createTable;
+(BOOL)insertData:(NSArray *)data tableName:(NSString *)aName;
+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(id)aValue;
+(BOOL)deleteALLData:(NSString *)tableName;
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue conditionColumn:(NSString *)conColumn conditionColumnValue:(id)conValue;
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue  withAll:(BOOL)yesNO;
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn noEqualValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

+(NSArray *)selectColumn:(NSString *)theColumn tableName:(NSString *)aTableName conColumn:(NSString *)aColumn conColumnValue:(NSString *)aColumnValue withWholeColumn:(BOOL)yesNO;
+(NSArray *)selectTopNColumn:(NSString *)theColumn tableName:(NSString *)aTableName rowNum:(NSInteger)n;
+(NSArray *)selectColumnWithOrder:(NSString *)theColumn tableName:(NSString *)aTableName conColumn:(NSString *)aColumn conColumnValue:(NSString *)aColumnValue orderBy:(NSString *)descOrAsc;
+(BOOL)insertDataWithnotAutoID:(NSArray *)data tableName:(NSString *)aName;
//get goodsclass 
+(NSArray *)getGoodsClassfromBaseGoodsClass:(NSString *)aColumn conColumnValue:(NSString *)aValue;
+(NSArray *)getGoodsClassfromTopics:(NSString *)aColumn conColumnValue:(NSString *)aValue;
+(NSMutableArray *)getVIPCardArrayWithConditionColumn:(NSString *)aColumn coColumnValue:(NSString *)aValue;
+(NSMutableArray *)getBankCardArrayWithConditionColumn:(NSString *)aColumn coColumnValue:(NSString *)aValue;
//get Notes class 便签
+(NSMutableArray *)getNotesClass;
//得到指定行数的Notes记录,n为0则选择所有行
+(NSMutableArray *)getNotesClassSpecifyRowAmount:(NSInteger)n withOrder:(NSString *)order;

//ADD BY MIAOYUNZ
+(BOOL)deleteData:(NSString *)tableName;
//+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
//		condition:(NSString *)con;
//+(BOOL)deleteData:(NSString *)tableName condition:(NSString *)con;
+(NSArray *)getShoppingCartWithConditions:(NSString *)aColumn  columnValue:(NSString *)aValue;
//------
//add by zhanghao
//查询购物车中所有商品的总数
+(NSString *)getTotalCountOfCartGoods:(NSString *)VIPID;


//两个查询条件 select * from tabelName where columnOne=valueOne and columnTow=calueTwo
+(NSArray *)qureyWithTwoConditions:(NSString *)tabelName ColumnOne:(NSString *)columnOne valueOne:(NSString *)valueOne columnTwo:(NSString *)columnTwo valueTwo:(NSString *)valueTwo;
//带两个条件的更新
//update tabelName set Column=aValue where columnOne=valueOne and columnTwo=valueTwo
+(BOOL)updateWithTwoConditions:(NSString *)tabelName theColumn:(NSString *)Column theColumnValue:(NSString *)aValue ColumnOne:(NSString *)columnOne valueOne:(NSString *)valueOne columnTwo:(NSString *)columnTwo valueTwo:(NSString *)valueTwo;
//带两个条件的删除 
//delete from tablename where columnOnew=columnOne and columnTwo=colunmTwo
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName columnOne:(NSString *)columnOne valueOne:(NSString *)valueOne columnTwo:(NSString *)columnTwo  valueTwo:(NSString *)valueTwo;

//得到主题生活类
+ (NSMutableArray *)getTopicClass:(NSString *)aColumn columnValue:(NSString *)aValue;

+ (BOOL)checkBankCardExit:(NSString *)userID cardNO:(NSString *)cardNO cardName:(NSString *)cardName;
+ (BOOL)checkVIPCardExit:(NSString *)userID cardNO:(NSString *)cardNO comID:(NSString *)comID typeName:(NSString *)typeName;

@end
