//
//  CityTableViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "CityTableViewController.h"
#import "ElApiService.h"
#import "Constants.h"
#import "NSString+Contains.h"
@interface CityTableViewController ()

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"城市列表";
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_cityList!=nil){
        return [_cityList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    
    TDCityInfo *city=[_cityList objectAtIndex:indexPath.row];
    
    
    
    [cell.textLabel setText:city.name];
    
    int  cityID=[[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CITY_ID] intValue];

    if(cityID==city.cityId){
            
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.3]];
    }else{
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDCityInfo *city=[_cityList objectAtIndex:indexPath.row];
    
    
    
    NSString *citname=city.name;
    
    if(![citname myContainsString:@"市"]){
        citname=[NSString stringWithFormat:@"%@市",city.name];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(city.cityId) forKey:KEY_CITY_ID];
    [[NSUserDefaults standardUserDefaults] setObject:citname forKey:KEY_CITY_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:KEY_TO_DOOR];
    
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
