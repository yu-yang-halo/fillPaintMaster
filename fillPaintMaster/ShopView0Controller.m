//
//  ShopView0Controller.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopView0Controller.h"
#import <UIView+Toast.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TDAlbumViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "Constants.h"
#import "ElApiService.h"
#import "My360ViewObject.h"
#import "PanoramaViewController.h"

@interface ShopView0Controller ()<BMKMapViewDelegate>
{
   BMKMapView  *mapView;
   NSArray *shopInfos;
   TDShopInfo *myShop;
   int shopId;
   My360ViewObject *viewObject;
   
}
@property (retain, nonatomic) UIWebView *webView;
@end

@implementation ShopView0Controller

- (void)viewDidLoad {
    [super viewDidLoad];
 
    mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [mapView setZoomLevel:13];
    [self.view addSubview:mapView];
    
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:@"shopId"] intValue];
    viewObject=[[My360ViewObject alloc] init];
    

    
    [self netDataGet];
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        shopInfos=[[ElApiService shareElApiService] getShopList];
       
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (TDShopInfo *shop in shopInfos) {
                if(shop.shopId==shopId){
                    myShop=shop;
                    break;
                }
            }
            [self locationNewCenter];
            
            
        });
    });
}
-(void)locationNewCenter{
    if(myShop==nil){
        return;
    }
    CLLocationCoordinate2D co2d=CLLocationCoordinate2DMake(myShop.latitude, myShop.longitude);
    
    [mapView setCenterCoordinate:co2d animated:YES];
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude =myShop.latitude;
    coor.longitude = myShop.longitude;
    annotation.coordinate = coor;
    annotation.title =myShop.name;
   
    [mapView addAnnotation:annotation];
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



-(void)viewDidLayoutSubviews{
  
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
/*
 #pragma mark - BaiduMap delegate
 */

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.image=[UIImage imageNamed:@"maker"];
        
        
        
        [viewObject.nameLabel setText:annotation.title];
        
        newAnnotationView.paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:viewObject.m360View];
        
        [viewObject.my360Button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        return newAnnotationView;
    }
    return nil;
}

-(void)click:(id)sender{
    NSLog(@"click...");
    
    PanoramaViewController *panoramaVC=[[PanoramaViewController alloc] init];
    panoramaVC.panorama=myShop.panorama;
    panoramaVC.title=myShop.name;
    
    
    [self.tdShopVCDelegate.navigationController pushViewController:panoramaVC animated:YES];
    
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    // NSLog(@"didSelectAnnotationView %@",view);
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    // NSLog(@"annotationViewForBubble %@ tag:%ld",view,view.tag);
    
}

@end
