//
//  TDUserCenterViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/1/5.
//  Copyright (c) 2016年 LZTech. All rights reserved.
//

#import "TDUserCenterViewController.h"
#import "CoolNavi.h"
static const float ROW_HEIGHT=60;
static CGFloat const kWindowHeight = 205.0f;
@interface TDUserCenterViewController (){
    NSArray *items;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TDUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items=@[@"我的订单",@"我的预约",@"我的服务卡",@"优惠券"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setRowHeight:ROW_HEIGHT];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    CoolNavi *headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), kWindowHeight)backGroudImage:@"background" headerImageURL:@"http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4f263b0fc3adbb6fd52663334.jpg" title:@"1595435345" subTitle:@"车牌:皖APS890"];
    [headerView setBackgroundColor:[UIColor orangeColor]];
    headerView.scrollView = self.tableView;
    headerView.imgActionBlock = ^(){
        NSLog(@"headerImageAction");
    };
    [self.view addSubview:headerView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

#pragma mark DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"mTableCell";
    UITableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableCell==nil){
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [tableCell.textLabel setText:[items objectAtIndex:indexPath.row]];
    return tableCell;
    
}


@end
