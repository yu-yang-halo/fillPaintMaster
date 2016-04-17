//
//  HeaderUViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "HeaderUViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import <MMPopupView/MMSheetView.h>
@interface HeaderUViewController ()

@end

@implementation HeaderUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    if([_carInfos count]>0){
        
        int carId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CAR_ID] intValue];
        TDCarInfo *carInfo=nil;
        if(carId<=0){
            carInfo=[_carInfos objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:@(carInfo.carId) forKey:KEY_CAR_ID];
        }else{
            carInfo=[self findCarInfo:carId];
        }
        
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:carInfo.number style:UIBarButtonItemStylePlain target:self action:@selector(selectCar)];
        
        
    }
}

-(TDCarInfo *)findCarInfo:(int)carId{
    TDCarInfo *mcar=nil;
    for (TDCarInfo *car in _carInfos) {
        if(car.carId==carId){
            mcar=car;
            break;
        }
    }
    if(mcar==nil&&[_carInfos count]>0){
        mcar=[_carInfos objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:@(mcar.carId) forKey:KEY_CAR_ID];
        
    }
    return mcar;
}
-(void)selectCar{
    MMPopupCompletionBlock completeBlock=^(MMPopupView *view, BOOL complete) {
        NSLog(@"view %@,complete %d",view,complete);
    };
    MMPopupItemHandler block=^(NSInteger index) {
        TDCarInfo *car=_carInfos[index];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(car.carId) forKey:KEY_CAR_ID];
        
        self.navigationItem.rightBarButtonItem.title=car.number;
        
    };
    
    NSMutableArray *items=[[NSMutableArray alloc] init];
    int selectCarId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CAR_ID] intValue];
    for (TDCarInfo *carInfo in _carInfos) {
        if(carInfo.carId==selectCarId){
            [items addObject:MMItemMake(carInfo.number, MMItemTypeHighlight,block)];
        }else{
            [items addObject:MMItemMake(carInfo.number, MMItemTypeNormal,block)];
        }
        
    }
    
    MMSheetView *sheetView=[[MMSheetView alloc] initWithTitle:@"选择车牌" items:items];
    [sheetView showWithBlock:completeBlock];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
