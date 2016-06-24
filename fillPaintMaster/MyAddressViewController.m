//
//  MyAddressViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/6/23.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "MyAddressViewController.h"
#import "UserAddressManager.h"
#import "ElApiService.h"
@interface MyAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    UITextView *firstResponderTF;
    CGFloat kbHeight;
    double  duration;
}
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的地址";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _nameLabel.delegate=self;
    _phoneLabel.delegate=self;
    _addressLabel.delegate=self;
    
    _addressLabel.layer.borderColor=[[UIColor colorWithWhite:0.8 alpha:0.9] CGColor];
    _addressLabel.layer.borderWidth=1;
    _addressLabel.layer.cornerRadius=3;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_NAME];
    NSString *phone=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PHONE];
    NSString *address=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ADDRESS];
    
    self.nameLabel.text=name==nil?@"":name;
    self.phoneLabel.text=phone==nil?@"":phone;
    self.addressLabel.text=address==nil?@"":address;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSString *name=self.nameLabel.text;
    NSString *phone=self.phoneLabel.text;
    NSString *address=self.addressLabel.text;
    
    if([name isEqualToString:@""]||[phone isEqualToString:@""]||[address isEqualToString:@""]){
        return;
    }
    
    NSString *receivingInfo=[UserAddressManager cacheName:name phone:phone address:address];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
       TDUser *user=[[ElApiService shareElApiService] getUserInfo];
       [user setReceivingInfo:receivingInfo];
        
       [[ElApiService shareElApiService] updUser:user];
        
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
       });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextField delegate
-(void)autoLayoutSelfView{
    if(kbHeight<=0||firstResponderTF==nil){
        return;
    }
    CGFloat offset=0;
    
    
    CGFloat h=self.view.frame.size.height-firstResponderTF.frame.origin.y;
    
    if(kbHeight>h){
        offset=kbHeight-h;
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=-offset;
        
        self.view.frame=frame;
    }];
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    kbHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self autoLayoutSelfView];
}

-(void)keyBoardWillHide:(NSNotification *)notification{
    
    double duration2=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration2 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=0;
        self.view.frame=frame;
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    firstResponderTF=textView;
    [self autoLayoutSelfView];
     NSLog(@"textViewShouldBeginEditing");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textViewDidBeginEditing");
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
