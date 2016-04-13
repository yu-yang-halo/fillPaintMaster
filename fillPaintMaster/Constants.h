//
//  Constants.h
//  fillPaintMaster
//
//  Created by apple on 16/4/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*
     常量使用定义
 */

static const int SEARCH_TYPE_DECO=5;
static const int SEARCH_TYPE_OIL=6;
static const int SEARCH_TYPE_META=7;


static const int AC_TYPE_WASH=1000;
static const int AC_TYPE_OIL=1001;
static const int AC_TYPE_META=1002;

static const int AC_TYPE_META2=1003;

static const int AC_TYPE_GOOD=1004;


static const int AC_TYPE_ORDER_BEFORE=1004;
static const int AC_TYPE_ORDER_AFTER=1005;

static const int PAY_STATE_UNFINISHED=0;//支付状态未完成
static const int PAY_STATE_FINISHED=1;//支付状态已完成


static const int TYPE_PAY_ONLINE=0;//在线支付
static const int TYPE_PAY_TOSHOP=1;//到店支付
static const int STATE_ORDER_UNFINISHED=0;//订单状态未完成
static const int STATE_ORDER_FINISHED=1;//已经完成
static const int STATE_ORDER_WAIT=2;//等待客服确认
static const int STATE_ORDER_CANCEL=3;//取消

static const int SEARCH_SHOP=1;//搜索类型 按店搜索
static const int SEARCH_USER=2;//搜索类型 按用户搜索



static const NSString *KEY_LATLGT=@"latlgt";
static const NSString *KEY_LATLGT_CITYNAME=@"latlgt_city_name";

static const NSString *KEY_CITY_ID=@"selected_cityId";
static const NSString *KEY_CITY_NAME=@"selected_cityName";
static const NSString *KEY_TO_DOOR=@"toDoor";


#endif /* Constants_h */
