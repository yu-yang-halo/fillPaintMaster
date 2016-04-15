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
#import "Constants.h"
#import "ShopLocationsTableViewCell.h"

@interface TDStoreViewController ()<BMKMapViewDelegate,MyTabHandlerDelegate>
{
    BMKMapView  *mapView;
    UITableView *tableView;
    NSArray *shopInfos;
    TDUser *user;
    NSMutableArray *annotations;
}
@end

@implementation TDStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
     mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
     tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setRowHeight:120];
    
    
    
    [mapView setZoomLevel:12];
    
    [self.view addSubview:mapView];
    [self.view addSubview:tableView];
    [self.view bringSubviewToFront:tableView];
    
    [(TDTabViewController *)self.tabBarController setTabHandlerDelegate:self];

}

-(void)locationNewCenter{

    NSString *latlgtStr=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LATLGT];
    
    NSArray *latlgtArr=[latlgtStr componentsSeparatedByString:@","];
    if(latlgtArr!=nil&&[latlgtArr count]==2){
        [[latlgtArr objectAtIndex:0] floatValue];
        CLLocationCoordinate2D co2d=CLLocationCoordinate2DMake([[latlgtArr objectAtIndex:0] floatValue], [[latlgtArr objectAtIndex:1] floatValue]);
        
        [mapView setCenterCoordinate:co2d animated:YES];
        
       
    }
  
    
}

/*
     MyTabHandlerDelegate
 */
-(void)onModeSelected:(int)mode{
    if(mode==1){
         [self.view bringSubviewToFront:mapView];
    }else{
        [self.view bringSubviewToFront:tableView];
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
    [self netDataGet:-100];
    
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
   
}

-(void)netDataGet:(int)shopID{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(shopID<0){
        hud.labelText = @"数据加载中...";
    }else{
        hud.labelText = @"店铺切换中...";
    }
    
    int cityId=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_ID] intValue];
    
    
    
    
    
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
            
            
            if(user.shopId>0){
                [[NSUserDefaults standardUserDefaults] setObject:@(user.shopId) forKey:@"shopId"];
            }
            
            
            if(shopInfos!=nil){
                if(annotations!=nil){
                    [mapView removeAnnotations:annotations];
                }
                annotations=[[NSMutableArray alloc] init];
                
                for (TDShopInfo *shopInfo in shopInfos) {
                    
                    if(shopInfo.cityId==cityId){
                        // 添加一个PointAnnotation
                        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
                        CLLocationCoordinate2D coor;
                        coor.latitude =shopInfo.latitude;
                        coor.longitude = shopInfo.longitude;
                        annotation.coordinate = coor;
                        annotation.title =shopInfo.name;
                        [annotations addObject:annotation];
                    }
                    
                }
                [mapView addAnnotations:annotations];
            }
            [self locationNewCenter];
            
        });
    });
}

/*
#pragma mark - BaiduMap delegate
*/

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        NSArray *shopIDSelectedArr=[self getShopId:annotation.coordinate];
        newAnnotationView.tag=[shopIDSelectedArr[0] intValue];
        if([shopIDSelectedArr[1] boolValue]){
           
            newAnnotationView.image=[UIImage imageNamed:@"maker2"];
        }else{
            newAnnotationView.image=[UIImage imageNamed:@"maker"];
        }
        
        return newAnnotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
   // NSLog(@"didSelectAnnotationView %@",view);
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    // NSLog(@"annotationViewForBubble %@ tag:%ld",view,view.tag);
    
     [(BMKPinAnnotationView *)(view) setImage:[UIImage imageNamed:@"maker2"]];
    
    
    if(user.shopId!=view.tag){
        
        [self netDataGet:view.tag];
        
    }
}

/*
 * UITableView  delegate datasource
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopLocationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopLocationsTableViewCell"];
    if(cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"ShopLocationsTableViewCell" owner:self options:nil] lastObject];
    }
    
    

    
    return cell;
}




@end
