//
//  ShopView1Controller.m
//  fillPaintMaster
//
//  Created by apple on 16/1/1.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "ShopView1Controller.h"
#import "MonitorViewController.h"
#import "ElApiService.h"
@interface ShopView1Controller ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *cameras;
    int  shopId;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation ShopView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
   
    shopId=[[[NSUserDefaults standardUserDefaults] objectForKey:@"shopId"] intValue];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate  =self;
    _tableView.dataSource=self;
    _tableView.rowHeight=80;
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self.view addSubview:_tableView];
    [self netDataGet];
    
}
-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        cameras=[[ElApiService shareElApiService] getCameraList:shopId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
        });
    });
}

-(void)awakeFromNib{
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(cameras!=nil){
        return [cameras count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CameraListType *cameraListType=[cameras objectAtIndex:indexPath.row];
    
    cell.imageView.image=[UIImage imageNamed:@"icon_video"];
    cell.textLabel.text=cameraListType.name;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CameraListType *cameraListType=[cameras objectAtIndex:indexPath.row];
    
    MonitorViewController *monitorVC=[[MonitorViewController alloc] initUID:cameraListType.uid withPass:cameraListType.password];
   
    monitorVC.title=cameraListType.name;
    [self.tdShopVCDelegate.navigationController pushViewController:monitorVC animated:YES];
    
    
    
}
@end
