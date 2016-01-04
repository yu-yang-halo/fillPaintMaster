//
//  TDHttpDataService.m
//  fillPaintMaster
//
//  Created by admin on 16/1/4.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import "TDHttpDataService.h"
#import "TimeUtils.h"
#import "TDBaseTime.h"
#import "TDBeautyItem.h"
#import "TDOilItem.h"
#import "TDPaintItem.h"
#import "TDConstants.h"

@interface TDHttpDataService(){
    NSArray *items;
}
@end

@implementation TDHttpDataService


-(instancetype)init{
    self=[super init];
    if(self){
        items=@[@"C1-左前翼子板",
                         @"D1-左后翼子板",
                         @"E1-左前车门",
                         @"F1-左后车门",
                         @"J1-左裙边",
                         @"C2-右前翼子板",
                         @"D2-右后翼子板",
                         @"E2-右前车门",
                         @"F2-右后车门",
                         @"J2-右裙边",
                         @"A-前保险杠全喷",
                         @"A1-右前保险杠",
                         @"A2-左前保险杠",
                         @"B-后保险杠全喷",
                         @"B1-右后保险杠",
                         @"B2-左后保险杠",
                         @"G-前车盖",
                         @"H-后车盖",
                         @"I-车顶",
                         @"K1-左前反光板",
                         @"Q-门把手",
                         @"K2-右前反光镜"];

    }
    return self;
}

-(NSArray *)fetchAllCitys{
   
    return nil;
}
-(NSArray *)fetchAllOrderTimes{
    NSMutableArray *orderTimes=[[NSMutableArray alloc] init];
    
    for (int i=0;i<4;i++) {
        for (int j=0;j<6;j++) {
            TDBaseTime *tdBaseTime=[[TDBaseTime alloc] init];
            [tdBaseTime setTimeValue: [TimeUtils createTimeString:i column:j]];
            [tdBaseTime setSelectedYN:NO];
            if(j%2==0){
                [tdBaseTime setEnableYN:YES];
            }else{
                [tdBaseTime setEnableYN:NO];
            }
            [orderTimes addObject:tdBaseTime];
            
        }
    }
     return orderTimes;
}
-(NSArray *)fetchAllBeautyItems{
    NSMutableArray *beautyItems=[[NSMutableArray alloc] init];
    
    for (int i=0;i<6; i++) {
        TDBeautyItem *tdBeautyItem=[[TDBeautyItem alloc] init];
        
        [tdBeautyItem setItemName:[NSString stringWithFormat:@"洗车美容套餐%d",i]];
        [tdBeautyItem setItemPrice:(i+1)*50];
        
        [beautyItems addObject:tdBeautyItem];
        
        
    }
     return beautyItems;
}
-(NSArray *)fetchAllOilMaintainItems{
    NSMutableArray *oilItems=[[NSMutableArray alloc] init];
    
    for (int i=0;i<6; i++) {
        TDOilItem *tdOilItem=[[TDOilItem alloc] init];
        
        [tdOilItem setItemName:[NSString stringWithFormat:@"换油保养套餐%d",i]];
        [tdOilItem setItemPrice:(i+1)*50];
        
        [oilItems addObject:tdOilItem];
        
        
    }
    return oilItems;
}
-(NSArray *)fetchAllPaintItems{
    
    NSMutableArray *paintItems=[[NSMutableArray alloc] init];
    
    int size=CAR_TYPE_K2-CAR_TYPE_C1+1;
    
    
    for (int i=0;i<size; i++) {
        TDPaintItem *tdPaintItem=[[TDPaintItem alloc] init];
        
        [tdPaintItem setItemName:[items objectAtIndex:i]];
        [tdPaintItem setCarPositionType:CAR_TYPE_C1+i];
        
        [tdPaintItem setItemPrice:(i+1)*10+70];
        
        [paintItems addObject:tdPaintItem];
    }
    return paintItems;
}



@end
