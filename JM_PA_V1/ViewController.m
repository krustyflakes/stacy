//
//  ViewController.m
//  JM_PA_V1
//
//  Created by Julio Marquez on 10/12/15.
//  Copyright © 2015 Julio Marquez. All rights reserved.
//

#import "ViewController.h"
#import <ViewUtils/ViewUtils.h>
#import <AFNetworking/AFNetworking.h>
#import "ResultTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+SDColor.h"

@interface ViewController (){
  BOOL isSearching;
  MBProgressHUD *progressHUD;
}
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
  [self.view addGestureRecognizer:tap];
  
  self.searchField.returnKeyType = UIReturnKeySearch;
  self.searchField.keyboardType = UIKeyboardTypeAlphabet;
  
  progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:progressHUD];
  
  progressHUD.mode = MBProgressHUDModeIndeterminate;
  progressHUD.animationType = MBProgressHUDAnimationFade;
  progressHUD.dimBackground = YES;
  progressHUD.labelText = @"Searching";
  [progressHUD hide:YES];
  self.view.backgroundColor = [UIColor hex:0x63CEF3];

}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.searchField becomeFirstResponder];
  self.msgLabel.text = @"Acronyms/Initialism";
}

-(void)onTap:(UITapGestureRecognizer*)sender{
  [self searhAcro];
}

-(void)searhAcro{
  
  if(self.searchField.text.length < 1){
    isSearching = NO;
    return;
  }
  
  NSString *URLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
  NSDictionary *parameters = @{@"sf": self.searchField.text};
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  
  [progressHUD show:YES];
  [self.searchField resignFirstResponder];

  self.msgLabel.text = @"";
  
  [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    isSearching = NO;
    [progressHUD hide:YES];
    NSArray *array = [[NSArray alloc] initWithArray:(NSArray*)responseObject];
    if(array.count > 0){
      NSDictionary *response = array[0];
      ResultTableViewController *resultTVC = [[ResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
      resultTVC.data = response;
      [self.navigationController pushViewController:resultTVC animated:YES];
    }else{
      self.msgLabel.text = @"No matches found.";
    }
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {

  }];
  
  
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
  return ![string isEqualToString:@" "];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  if(!isSearching){
    isSearching = YES;
    [self searhAcro];
  }
  
  return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
  self.msgLabel.text = @"";
  return YES;
}

@end
