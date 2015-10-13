//
//  ResultTableViewController.m
//  JM_PA_V1
//
//  Created by Julio Marquez on 10/12/15.
//  Copyright © 2015 Julio Marquez. All rights reserved.
//


#import "ResultTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ResultTableViewController (){
  NSString *acroString;
  NSArray *results;
  UIPasteboard *pasteBoard;
  MBProgressHUD *progressHUD;
}

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  
  results = [[NSArray alloc] initWithArray:self.data[@"lfs"]];
  acroString = self.data[@"sf"];
  
  self.title = acroString;
  
  pasteBoard = [UIPasteboard generalPasteboard];
  
  progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:progressHUD];
  
  progressHUD.mode = MBProgressHUDModeText;
  progressHUD.animationType = MBProgressHUDModeText;
  progressHUD.dimBackground = NO;
  progressHUD.labelText = @"Copied to clipboard";
  [progressHUD hide:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:10];
  }
  
  cell.textLabel.text = results[indexPath.row][@"lf"];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"used since: %@ | frequency: %@", results[indexPath.row][@"since"], results[indexPath.row][@"freq"]];
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [progressHUD show:YES];
  [pasteBoard setString:results[indexPath.row][@"lf"]];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [progressHUD hide:YES afterDelay:0.5];
}

@end
