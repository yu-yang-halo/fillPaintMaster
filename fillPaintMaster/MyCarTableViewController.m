//
//  MyCarTableViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyCarTableViewController.h"
#import "ElApiService.h"
#import <MJRefresh/MJRefresh.h>
#import <MMPopupView/MMAlertView.h>
#import <UIView+Toast.h>
@interface MyCarTableViewController ()
{
    NSMutableArray *carList;
    MJRefreshNormalHeader *refreshHeader;
    
}
@end

@implementation MyCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的车牌";
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addCar)];
    
    
    refreshHeader=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self netDataGet];
    }];
    [refreshHeader.lastUpdatedTimeLabel setHidden:YES];
    self.tableView.mj_header=refreshHeader;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // 马上进入刷新状态
    [refreshHeader beginRefreshing];
    
    
}
-(void)addCar{
    MMAlertView *mmAlertView0=[[MMAlertView alloc] initWithInputTitle:@"输入车型号" detail:@"" placeholder:@"例如:奥迪 Q5" handler:^(NSString *carType) {
        NSLog(@"型号 %@",carType);
        if([[carType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [self.view.window makeToast:@"型号不能为空"];
        }else{
           
            MMAlertView *mmAlertView=[[MMAlertView alloc] initWithInputTitle:@"添加车牌号" detail:@"" placeholder:@"例如:皖A 88888" handler:^(NSString *text) {
                NSLog(@"text %@",text);
                if([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                    [self.view.window makeToast:@"车牌不能为空"];
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        TDCarInfo *carInfo=[[TDCarInfo alloc] init];
                        [carInfo setNumber:text];
                        [carInfo setType:0];
                        [carInfo setModel:carType];
                        [[ElApiService shareElApiService] createCar:carInfo];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self netDataGet];
                        });
                        
                    });
                }
                
                
            }];
            
            [mmAlertView show];
            
            
        }
        
        
    }];
    
    [mmAlertView0 show];
    
   
    
}



-(void)netDataGet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        carList=[[ElApiService shareElApiService] getCarByCurrentUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshHeader endRefreshing];
        });
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(carList!=nil){
        return [carList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    TDCarInfo *carinfo=[carList objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@      %@",carinfo.number,carinfo.model]];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
        TDCarInfo  *carInfo=[carList objectAtIndex:indexPath.row];
        int carID=carInfo.carId;
        [carList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ElApiService shareElApiService] delCar:carID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self netDataGet];
            });
            
        });
        
        
        
      
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
