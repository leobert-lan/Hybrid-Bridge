//
//  LanguageVC.m
//  H5
//
//  Created by zhchen on 16/4/14.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "LanguageVC.h"
#import "LanguageManager.h"
#import "AppDelegate.h"
@interface LanguageVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *data;
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@end

@implementation LanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [LanguageManager languageStrings];
    [LanguageManager setupCurrentLanguage];
    self.bottomLeftLabel.text = NSLocalizedStringFromTable(@"Happy New Year", @"LanguageFile",nil);
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ELanguageCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = data[indexPath.row];
    if (indexPath.row == [LanguageManager currentLanguageIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [LanguageManager saveLanguageByIndex:indexPath.row];
    [self.tableView reloadData];
    [self reloadRootViewController];
}

- (void)reloadRootViewController
{
    self.bottomLeftLabel.text = NSLocalizedStringFromTable(@"Happy New Year", @"LanguageFile",nil);

//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *storyboardName = @"LanguageVC";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LanguageVC"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
