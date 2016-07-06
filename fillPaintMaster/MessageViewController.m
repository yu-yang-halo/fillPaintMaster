//
//  MessageViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/7/6.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageManager.h"
@interface MessageViewController ()
@property(nonatomic,strong) NSMutableArray *messageStack;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新消息";
    self.messageStack=[NSMutableArray new];
    
    NSArray *msglist=[MessageManager getJPMessageArray];
    if(msglist!=nil&&[msglist count]>0){
        for (int i=[msglist count]-1;i>=0;i--) {
           
            [_messageStack addObject: [msglist objectAtIndex:i]];
        }
    }
    
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [MessageManager emptyJPMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_messageStack count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"]
        ;
    }
    NSString *text=[[_messageStack objectAtIndex:indexPath.row] msgContent];
    CGSize size=[text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    CGSize testSize=[@"test" sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    
    int numbers=size.height/testSize.height;
    NSLog(@"numbers %d",numbers);
    
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14] ];
    [cell.textLabel setText:text];
    
    CGRect labelFrame=cell.textLabel.frame;
    labelFrame.size.height=size.height+15;
     labelFrame.size.width=tableView.frame.size.width;
    cell.textLabel.frame=labelFrame;
    
    [cell.textLabel setNumberOfLines:numbers];
    cell.textLabel.lineBreakMode=NSLineBreakByCharWrapping;
    
    CGRect frame=cell.frame;
    frame.size.height=size.height+15;
    cell.frame=frame;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
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
