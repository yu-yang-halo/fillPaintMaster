//
//  TDActiveViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDActiveViewController.h"
#import "TDActiveTableViewCell.h"
@interface TDActiveViewController (){
    NSArray *activeItems;
    NSArray *activeNumbers;
    NSArray *activeIcons;
}
@property(nonatomic,retain) UITableView *tableView;

@end

@implementation TDActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height-64-49)];
    
    activeItems=@[@"门店兑换码",@"油行天下"];
    activeNumbers=@[@"已有20012人参加",@"已有10023人参加"];
    activeIcons=@[@"active_01",@"active_02"];
    self.tableView.rowHeight=197;
    self.tableView.delegate   =self;
    self.tableView.dataSource =self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
    
    [self.view addSubview:_tableView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//activeCell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [activeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDActiveTableViewCell *activeTableCell=[tableView dequeueReusableCellWithIdentifier:@"activeCell"];
    if(activeTableCell==nil){
        activeTableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDActiveTableViewCell" owner:self options:nil] lastObject];
        
        NSLog(@"new ....");
        
    }
    [activeTableCell.activeNameLabel setText:[activeItems objectAtIndex:indexPath.row]];
    [activeTableCell.activeNumsLabel setText:[activeNumbers objectAtIndex:indexPath.row]];
    [activeTableCell.activeImageView setImage:[UIImage imageNamed:[activeIcons objectAtIndex:indexPath.row]]];
    
    return activeTableCell;
    
}



@end
