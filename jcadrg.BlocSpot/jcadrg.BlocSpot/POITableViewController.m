//
//  POITableViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "POITableViewController.h"
#import "ViewController.h"
#import "POITableViewCell.h"
#import "POI.h"

#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"


@interface POITableViewController ()<UISearchBarDelegate, UISearchControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) ViewController *mapVC;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *mapBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *labelBarButtonItem;

@end

@implementation POITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.hidesBackButton = YES;
    self.mapVC = [[ViewController alloc] init];
    [self.tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:@"POI"];
    
    
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:[UIColor midnightBlueColor], NSFontAttributeName:[UIFont boldFlatFontOfSize:18]};
    
    [self addLeftButton];
    [self addRightButton];
    [self setUpSearchBar];

}

-(void) addLeftButton{
    CGSize max = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [self titleString];
    
    CGSize maxSize = [label sizeThatFits:max];
    
    UIView *custom =[[UIView alloc] initWithFrame:CGRectMake(0, 0,maxSize.width , maxSize.height)];
    label.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
    
    [custom addSubview:label];
    self.labelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:custom];
    
    UIImage *mapViewImage = [UIImage imageNamed:@"location"];
    self.labelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mapViewImage
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(mapViewTap:)];
    
    [_mapBarButtonItem configureFlatButtonWithColor:[UIColor midnightBlueColor]
                                   highlightedColor:[UIColor wetAsphaltColor]
                                       cornerRadius:3];
    
    [_mapBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItems = @[_mapBarButtonItem, _labelBarButtonItem];
    
    
}

//Action when left button is pressed
-(NSAttributedString *) titleString{
    NSString *string = @"BlocSpot";
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor], NSFontAttributeName:[UIFont boldFlatFontOfSize:18]}];
    
    return attributedString;
}

-(void) addRightButton{
    UIImage *search = [UIImage imageNamed:@"quest"];
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:search
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(searchPressed:)];
    
    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    
    [_searchButton setTintColor:[UIColor whiteColor]];
    
    UIImage *filter =[UIImage imageNamed:@"sorting_answers_filled"];
    self.filterButton = [[UIBarButtonItem alloc] initWithImage:filter
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(filterPressed:)];
    
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_filterButton setTintColor:[UIColor whiteColor]];
    
    
    self.navigationItem.rightBarButtonItems = @[_filterButton, _searchButton];
    
}

-(void) setUpSearchBar{
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate= self;
    
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

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POI" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Button actions


-(void) searchPressed:(id) sender{
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.50
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         _searchBar.alpha=1.0;
                         
                         //removing other buttons
                         self.navigationItem.rightBarButtonItems= nil;
                         self.navigationItem.leftBarButtonItems = nil;
                         self.navigationItem.titleView=_searchBar;
                         
                         [_searchBar becomeFirstResponder];
                     }
                     completion:^(BOOL finished){
                         
                     }];
   
    
}

-(void) mapViewTap:(id) sender{
    if (self.mapVC) {
        [self.navigationController pushViewController:self.mapVC animated:YES];
    }
    
}

-(void) filterPressed:(id) sender{
    
}

#pragma mark - SearchBar method

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:kNilOptions
                     animations:^{
                         
                     }
                     completion:^(BOOL finished){
                         _searchBar.alpha=0;
                         
                         self.navigationItem.titleView = nil;
                         self.navigationItem.leftBarButtonItems =@[_mapBarButtonItem, _labelBarButtonItem];
                         self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
                     }];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
