//
//  PopUpCategoriesViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/7/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "PopUpCategoriesViewController.h"


#import "WYPopoverController.h"
#import "CategoryViewController.h"
#import "ViewController.h"
#import "CategoryTableViewCell.h"
#import "POITableViewController.h"
#import "CallOutView.h"
#import "DataSource.h"


@interface PopUpCategoriesViewController ()

@property (nonatomic, strong) CategoryViewController *categoryVCpopup;
@property (nonatomic, strong) POITableViewController *poiTableVC;
@property (nonatomic, strong) WYPopoverController *popover;
@property (nonatomic, strong) ViewController *mapVC;
@property (nonatomic, strong) UINavigationController *navVCPopup;

@property (nonatomic, strong) NSMutableArray *pickedCategories;

@end

@implementation PopUpCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   [[DataSource sharedInstance] addObserver:self forKeyPath:@"categories" options:0 context:nil];
    [self.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:@"categoryCell"];
}

-(void) dealloc{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"categories"];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Categories *item = [DataSource sharedInstance].categories[indexPath.row];
        
        NSLog(@"ALL CATEGORIES BEFORE DELETING = %@",[DataSource sharedInstance].categories);
        
        [[DataSource sharedInstance] deleteCategories:item];
        
        NSLog(@"ALL CATEGORIES AFTER DELETING = %@",[DataSource sharedInstance].categories);
        
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    cell.category = categories;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.state = CategoryTableViewCellStateSelectedYES;
    
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    self.pickedCategories = [NSMutableArray new];
    [self.pickedCategories addObject:categories];
    
    [self.popupDelegate getSelectedCategories:self.pickedCategories andProceed:YES];
    [self.popupDelegate getSelectedCategories:self.pickedCategories andProceed:NO];
    
    [cell setNeedsDisplay];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    [self.pickedCategories removeObject:categories];
    cell.state = CategoryTableViewCellStateUnSelectedNOT;
    
    [cell setNeedsDisplay];
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
