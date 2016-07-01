//
//  TDCarInfoViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDCarInfoViewController.h"
#import "CustomIOSAlertView.h"
#import "TDCarInfoModel.h"

@interface TDCarInfoViewController (){
    NSMutableArray *carInfos;
}
- (IBAction)back:(id)sender;
- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TDCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    ///[self.tableView setEditing:YES animated:YES];
    
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    carInfos=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [carInfos count];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle....");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [carInfos removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self.tableView reloadData];
    }
    
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *mTableCell= [tableView dequeueReusableCellWithIdentifier:@"mTableCell"];
    if (mTableCell==nil) {
        mTableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mTableCell"];
        
    }
    TDCarInfoData *carInfoData=[carInfos objectAtIndex:indexPath.row];
    
    [mTableCell.textLabel setText:[NSString stringWithFormat:@"车牌号：%@",carInfoData.cphTxt]];
    
    return mTableCell;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)add:(id)sender {
    TDCarInfoModel *infoModel=[[TDCarInfoModel alloc] init];
   CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setBackgroundColor:[UIColor purpleColor]];
    UIView *customView =infoModel.carInfoView;
    
    [alertView setButtonTitles:@[@"关闭",@"保存"]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if(buttonIndex==1){
            [carInfos addObject: infoModel.carInfoData];
            
            [self.tableView reloadData];
        }
//      NSLog(@"Block: Button at position %d is clicked on alertView %ld.  %@", buttonIndex, [alertView tag], infoModel.carInfoData);
//        [alertView close];
    }];
   customView.frame=CGRectMake(0,0, 320, 210);
   [alertView setUseMotionEffects:TRUE];
   [alertView setContainerView:customView];
   [alertView show];
    
}
@end
