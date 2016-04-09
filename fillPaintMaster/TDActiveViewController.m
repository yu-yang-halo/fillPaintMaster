//
//  TDActiveViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDActiveViewController.h"
#import "TDActiveTableViewCell.h"
#import "ElApiService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
@interface TDActiveViewController (){
   
    NSArray *promotionList;
}
@property(nonatomic,retain) UITableView *tableView;

@end

@implementation TDActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height-64-49)];
     self.tableView.rowHeight=130;
     self.tableView.delegate   =self;
     self.tableView.dataSource =self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
    
    [self.view addSubview:_tableView];
    
    [self netDataGet];
    
}

-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        promotionList=[[ElApiService shareElApiService] getPromotionList:-1];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(promotionList!=nil){
                [self.tableView reloadData];
            }
            
        });
        
        
    });
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(promotionList!=nil){
       TDPromotionInfoType *promotion=[promotionList objectAtIndex:indexPath.row];
        NSLog(@"select %@",promotion.src);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText = @"领取中...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isSUC=[[ElApiService shareElApiService] updCoupon:promotion.typeId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [hud hide:YES];
                if(isSUC){
                    [self.view makeToast:@"活动优惠券领取成功"];
                }
                
            });
            
        });
        
    }
    
}

//activeCell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(promotionList!=nil)
    {
        return [promotionList count];
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDActiveTableViewCell *activeTableCell=[tableView dequeueReusableCellWithIdentifier:@"activeCell"];
    if(activeTableCell==nil){
        activeTableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDActiveTableViewCell" owner:self options:nil] lastObject];
        
        NSLog(@"new ....");
        
    }
    
    TDPromotionInfoType *promotionInfoType=[promotionList objectAtIndex:indexPath.row];
    
    NSString *urlImage=[[ElApiService shareElApiService] getPromotionURL:promotionInfoType.imgName];
    
    
    [activeTableCell.activeImageView sd_setImageWithURL:[NSURL URLWithString:urlImage] placeholderImage:nil];
    
    return activeTableCell;
    
}




@end
