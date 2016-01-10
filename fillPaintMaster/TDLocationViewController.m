//
//  TDLocationViewController.m
//  fillPaintMaster
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "TDLocationViewController.h"
#import "TDSearchViewController.h"
@interface TDLocationViewController (){
    NSArray *provinces;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)back:(id)sender;

@end

@implementation TDLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
   provinces= [[NSArray alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"city.plist"]];
   // NSLog(@"citys : %@",provinces);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath %@",indexPath);
    
    TDSearchViewController *tdSearchVC=[[TDSearchViewController alloc] init];
    
    [self presentViewController:tdSearchVC animated:YES completion:^{
         NSLog(@"Tslocation presentViewController...");
    }];
    
}




#pragma mark datasource
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[provinces objectAtIndex:section] objectForKey:@"state"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(tableCell==nil){
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    [tableCell.textLabel setText:[[[provinces objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row]];
    
    return tableCell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[provinces objectAtIndex:section] objectForKey:@"cities"] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [provinces count];
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
