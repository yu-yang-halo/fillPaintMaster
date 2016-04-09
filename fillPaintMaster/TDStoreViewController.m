//
//  TDStoreViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDStoreViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ElApiService.h"
#import "TDTabViewController.h"
#import "TDLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface TDStoreViewController ()<BMKMapViewDelegate>
{
    BMKMapView* mapView;
    NSArray *shopInfos;
    TDUser *user;
    NSMutableArray *annotations;
}
@end

@implementation TDStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    
    self.view = mapView;
    
   
    
    [self netDataGet:-100];
}
-(void)locationNewCenter{

    NSString *latlgtStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"latlgt"];
    
    NSArray *latlgtArr=[latlgtStr componentsSeparatedByString:@","];
    if(latlgtArr!=nil&&[latlgtArr count]==2){
        [[latlgtArr objectAtIndex:0] floatValue];
        CLLocationCoordinate2D co2d=CLLocationCoordinate2DMake([[latlgtArr objectAtIndex:0] floatValue], [[latlgtArr objectAtIndex:1] floatValue]);
        
        [mapView setCenterCoordinate:co2d animated:YES];
        
       
    }
  
    
}



-(NSArray *)getShopId:(CLLocationCoordinate2D)coor{
    int shopId=-100;
    BOOL selected=NO;
    
    for (TDShopInfo *shopInfo in shopInfos) {
        if(shopInfo.latitude==coor.latitude&&shopInfo.longitude==coor.longitude){
            shopId=shopInfo.shopId;
           
        }
        if(shopId==user.shopId){
            selected=YES;
        }
    }
    
    return @[@(shopId),@(selected)];
}

-(void)viewDidAppear:(BOOL)animated{
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
     mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
     mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLocationUpdate object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        NSArray *shopIDSelectedArr=[self getShopId:annotation.coordinate];
        newAnnotationView.tag=[shopIDSelectedArr[0] intValue];
        if([shopIDSelectedArr[1] boolValue]){
            newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        }else{
            newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        }
        
        return newAnnotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
   // NSLog(@"didSelectAnnotationView %@",view);
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
     NSLog(@"annotationViewForBubble %@ tag:%ld",view,view.tag);
    [(BMKPinAnnotationView *)(view) setPinColor:BMKPinAnnotationColorGreen];
    
    
    
    if(user.shopId!=view.tag){
        
        [self netDataGet:view.tag];
        
    }
}

-(void)netDataGet:(int)shopID{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"数据处理中...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(shopID>0){
            NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
            NSString *pass=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
            
            user.shopId=shopID;
            [[ElApiService shareElApiService] updUser:user];
            [[ElApiService shareElApiService] appUserLogin:name password:pass shopId:-1];
        }else{
            user=[[ElApiService shareElApiService] getUserInfo];
        }
        shopInfos=[[ElApiService shareElApiService] getShopList];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            
            if(shopInfos!=nil){
                if(annotations!=nil){
                    [mapView removeAnnotations:annotations];
                }
                annotations=[[NSMutableArray alloc] init];
                
                for (TDShopInfo *shopInfo in shopInfos) {
                    // 添加一个PointAnnotation
                    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
                    CLLocationCoordinate2D coor;
                    coor.latitude =shopInfo.latitude;
                    coor.longitude = shopInfo.longitude;
                    annotation.coordinate = coor;
                    annotation.title =shopInfo.name;
                    [annotations addObject:annotation];
                    
                }
                [mapView addAnnotations:annotations];
            }
            [self locationNewCenter];
            
        });
    });
}

@end
