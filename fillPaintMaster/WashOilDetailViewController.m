//
//  WashOilDetailViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/6/24.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "WashOilDetailViewController.h"
#import "WashOilTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import "ElApiService.h"
@interface WashOilDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL imageNetLoadCompleteYN;
}
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@property(nonatomic,strong) NSMutableArray *weburls;

@end

@implementation WashOilDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageNetLoadCompleteYN=NO;
    self.detailLabel.text=_desc;
    self.itemButton.layer.cornerRadius=5;
    [self.itemButton addTarget:self action:@selector(toBuyItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weburls=[NSMutableArray new];

    NSArray *imageNames=[_src componentsSeparatedByString:@","];
    for (NSString *imageName in imageNames) {
        if(_type==CarBeautyType_beauty){
             NSString *url=[[ElApiService shareElApiService] getDecoItemURL:_itemId imageName:imageName];
             [_weburls addObject:url];
        }else if(_type==CarBeautyType_oil){
            NSString *url=[[ElApiService shareElApiService] getOilItemURL:_itemId imageName:imageName];
            [_weburls addObject:url];
        }
        
      
      
    }
    
    

    
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
}

-(void)toBuyItem:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_weburls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"WashOilItem";
    WashOilTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"WashOilTableViewCell" owner:nil options:nil] lastObject];
        
    }
    NSString *url=[_weburls objectAtIndex:indexPath.row];
    NSLog(@"url %@",url);
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    NSLog(@"cell.cellImageView %@ H:%f W:%f",cell.cellImageView,cell.cellImageView.image.size.height,cell.cellImageView.image.size.width);
    [cell setUserInteractionEnabled:NO];
    
    
    CGRect frame=cell.frame;
    frame.size.height=[self scaleHeight:cell.cellImageView.image];
    
    cell.frame=frame;
    
    return cell;
}

-(CGFloat)scaleHeight:(UIImage *)image{
    if(image.size.height==0||image.size.width==0){
        return 10;
    }
    CGFloat scaleH=image.size.height*_tableView.frame.size.width/image.size.width;
    return scaleH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
     NSLog(@"cell.frame.size.height %f ",cell.frame.size.height);
    return cell.frame.size.height;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

@end
