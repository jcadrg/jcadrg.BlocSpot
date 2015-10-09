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
#import "FlatUIKit.h"

#import "DataSource.h"
#import "WYPopoverController.h"

#import "PopUpCategoriesViewController.h"
#import "SearchResultsTableVCViewController.h"

typedef NS_ENUM(NSInteger, TableSearchScope){
    searchScopeTitle = 0,
    searchScopeCategory = 1
};


@interface POITableViewController ()<UISearchBarDelegate, UISearchControllerDelegate, POITableViewCellDelegate, UISearchResultsUpdating, WYPopoverControllerDelegate, PopUpCategoriesViewControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) PopUpCategoriesViewController *categoryPopupVC;
@property (nonatomic, strong) WYPopoverController *popover;

@property (nonatomic, strong) ViewController *mapVC;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *mapBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *labelBarButtonItem;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@property (nonatomic, strong) NSString *categoryFilterSearchString;
@property (nonatomic, strong) UINavigationController *searchNavVC;
@property (nonatomic, strong) NSDictionary *distanceValues;

//secondary search result table view
@property (nonatomic, strong) SearchResultsTableVCViewController *searchResultsTableVC;

//state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property BOOL shouldGetSearchFromFilter;
@property BOOL isCategorySelected;


@end

@implementation POITableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapVC = [[ViewController alloc]init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"annotations" options:0 context:nil];
    //    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"categories" options:0 context:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:@"Points"];
    
    // Adding a title and setting its attributes
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]};
    
    [self addLeftBarButton];
    [self addRightBarButttons];
    
    
    _searchResultsTableVC = [[SearchResultsTableVCViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsTableVC];
    
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext =YES;
    
    
    
    if(!_categoryPopupVC){
        self.categoryPopupVC = [[PopUpCategoriesViewController alloc]init];
        self.categoryPopupVC.popupDelegate = self;
    }
    UINavigationController *navVCPopup =[[UINavigationController alloc]initWithRootViewController:self.categoryPopupVC];
    UIBarButtonItem *leftBarButtonPopup = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(popupBarButtonItemDonePressed:)];
    
    self.categoryPopupVC.navigationItem.leftBarButtonItem = leftBarButtonPopup;
    UIBarButtonItem *rightBarButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelFilterCategoryPressed:)];
    
    self.categoryPopupVC.navigationItem.rightBarButtonItem = rightBarButtonPopup;
    
    self.categoryPopupVC.navigationItem.title = @"Filter by Category";
    
    if (!_popover){
        self.popover = [[WYPopoverController alloc]initWithContentViewController:navVCPopup];
        self.popover.delegate = self;
        self.popover.popoverContentSize = CGSizeMake(self.popover.contentViewController.view.frame.size.width, 44*7 + 20);
        
    }
    
    if(!_categoryPopupVC){
        self.categoryPopupVC = [[PopUpCategoriesViewController alloc]init];
        self.categoryPopupVC.popupDelegate = self;
    }
    
    
    _shouldGetSearchFromFilter = NO;
    self.isCategorySelected = NO;
    [self.tableView reloadData];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}
-(void)dealloc
{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"annotations"];
    //    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"categories"];
    
}





-(void)addLeftBarButton {
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    
    UILabel *label = [[UILabel alloc]init];
    label.attributedText = [self titleLabelString];
    
    CGSize labelMaxSize = [label sizeThatFits:maxSize];
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height)];
    label.frame = CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height);
    
    [customView addSubview:label];
    //    self.labelBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    
    UIImage *mapImage = [UIImage imageNamed:@"quest"];
    self.mapBarButtonItem = [[UIBarButtonItem alloc]initWithImage:mapImage
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(mapViewPressed:)];
    [_mapBarButtonItem configureFlatButtonWithColor:[UIColor midnightBlueColor]
                                   highlightedColor:[UIColor wetAsphaltColor]
                                       cornerRadius:3];
    [_mapBarButtonItem setTintColor:[UIColor clearColor]];
    self.navigationItem.leftBarButtonItem = _mapBarButtonItem;
    self.navigationItem.titleView = customView;
    
}

#pragma mark Attributed Strings



-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"BlocSpot";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

-(NSAttributedString *)distanceStringWithString:(NSString *)string
{
    
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName :[UIFont flatFontOfSize:11] }];
    NSRange stringRange = [string rangeOfString:string];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    
    return mutAttString;
    
}


-(void) addRightBarButttons {
    
    //    UIImage *searchImage =[UIImage imageNamed:@"search"];
    //
    //    self.searchButton = [[UIBarButtonItem alloc]initWithImage:searchImage
    //                                                                    style:UIBarButtonItemStylePlain
    //                                                                   target:self
    //                                                                   action:@selector(searchButtonPressed:)];
    //    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
    //                              highlightedColor:[UIColor wetAsphaltColor]
    //                                  cornerRadius:3];
    //    [_searchButton setTintColor:[UIColor buttsColor]];
    UIImage *filterImage=[UIImage imageNamed:@"sorting_answers_filled"];
    
    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(filterButtonPressed:)];
    
    
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_filterButton setTintColor:[UIColor cloudsColor]];
    
    //filterButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationItem.rightBarButtonItem = _filterButton;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger arrayCount;
    
    if (!self.isCategorySelected)
    {
        arrayCount= [DataSource sharedInstance].annotations.count;
    }
    else
    {
        arrayCount = self.filteredArray.count;
    }
    
    
    return arrayCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    POI *poi = [DataSource sharedInstance].annotations[indexPath.row];
    
    [self.navigationController pushViewController:self.mapVC animated:YES];
    [self.tableDelegate didSelectPOI:poi];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Points" forIndexPath:indexPath];
    
    if (!self.isCategorySelected)
    {
        
        POI *poi = [DataSource sharedInstance].annotations[indexPath.row];
        cell.delegate = self;
        cell.poi = poi;
        NSNumber *number = [DataSource sharedInstance].distanceValuesDictionary[poi.locationName];
        
        NSString *distanceStr;
        if (number.integerValue <=1){
            distanceStr = [NSString stringWithFormat:@" %li m", (long)number.integerValue];
        }
        if (number.integerValue >1){
            distanceStr = [NSString stringWithFormat:@" %li ms", (long)number.integerValue];
        }
        if (number.integerValue >1000)
        {
            distanceStr = [NSString stringWithFormat:@" %li km", number.integerValue/1000];
            
        }
        cell.distance.attributedText = [self distanceStringWithString:distanceStr];
        return cell;
    }
    else
    {
        POI *poi = self.filteredArray[indexPath.row];
        cell.delegate = self;
        cell.poi = poi;
        NSNumber *number = [DataSource sharedInstance].distanceValuesDictionary[poi.locationName];
        
        NSString *distanceStr;
        if (number.integerValue <=1){
            distanceStr = [NSString stringWithFormat:@" %li m", (long)number.integerValue];
        }
        if (number.integerValue >1){
            distanceStr = [NSString stringWithFormat:@" %li ms", (long)number.integerValue];
        }
        if (number.integerValue >1000)
        {
            distanceStr = [NSString stringWithFormat:@" %li km", number.integerValue/1000];
            
        }
        cell.distance.attributedText = [self distanceStringWithString:distanceStr];
        return cell;
    }
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isCategorySelected)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            POI *poi = [DataSource sharedInstance].annotations[indexPath.row];
            [[DataSource sharedInstance] deletePOI:poi];
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BLCPointOfInterest *POI = [[BLCPointOfInterest alloc]init];
    //return [BLCPoiTableViewCell heightForPointOfInterestCell:POI width:CGRectGetWidth(self.view.bounds)];
    return 100;
}

// HELPER FUNCTIONS FOR THE DATA SOURCE


-(NSMutableArray *)filterAnnotationsFromCategories:(NSArray *)categories
{
    NSMutableArray *mutArray = [NSMutableArray new];
    
    
    
    
    for (Categories *category in categories)
    {
        
        
        [mutArray addObjectsFromArray:category.poi];
        
    }
    NSMutableArray *annotationArray =[NSMutableArray new];
    
    for (POI *poi in mutArray)
    {
        for (POI *dataPOI in [DataSource sharedInstance].annotations)
        {
            if ([poi.locationName isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.locationName]] && [poi.note isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.note]])
            {
                
                [annotationArray addObject:poi];
                
                
            }
        }
        
    }
    
    NSLog(@"annotations ARRAY : %@", annotationArray);
    //    }
    
    return annotationArray;
    
    
}
#pragma mark BLCPoiTableViewCellDelegate

-(void)cellDidPressOnButton:(POITableViewCell *)cell {
    
    [[DataSource sharedInstance] toggleVisitedOnPOI:cell.poi];
    
}



#pragma mark UITabBar button actions
-(void)popupBarButtonItemDonePressed:(id)sender
{
    self.isCategorySelected = YES;
    [self.popover dismissPopoverAnimated:YES];
    [self.tableView reloadData];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    
}

-(void)cancelFilterCategoryPressed:(id)sender
{
    [self.popover dismissPopoverAnimated:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    
}
-(void)mapViewPressed:(id)sender {
    if (self.mapVC){
        [self.navigationController pushViewController:self.mapVC animated:YES];
    }
}
-(void)filterButtonPressed:(id)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         [self.navigationController.navigationItem.leftBarButtonItem setEnabled:NO];
                         [_popover presentPopoverFromBarButtonItem:self.filterButton
                                          permittedArrowDirections:WYPopoverArrowDirectionDown
                                                          animated:NO];
                         
                         //
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}
-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
}

-(void)getSelectedCategories:(NSArray *)categories andProceed:(BOOL)proceed
{
    if (!proceed)
    {
        self.filteredArray = [NSMutableArray arrayWithArray:[self filterAnnotationsFromCategories:categories]];
        
        
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

#pragma mark Key-Value Observing

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [DataSource sharedInstance] && ([keyPath isEqualToString:@"annotations"])) {
        // Nothing… YET
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        } else if (kindOfChange == NSKeyValueChangeInsertion ||
                   kindOfChange == NSKeyValueChangeRemoval ||
                   kindOfChange == NSKeyValueChangeReplacement) {
            // We have an incremental change: inserted, deleted, or replaced images
            
            // Get a list of the index (or indices) that changed
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // Call `beginUpdates` to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            // Tell the table view what the changes are
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Tell the table view that we're done telling it about changes, and to complete the animation
            [self.tableView endUpdates];
        }
    }
}

#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //     update the filtered array based on the search text
    //    searchController.prese
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [[DataSource sharedInstance].annotations  mutableCopy];
    
    // strip out all the leading and trailing spaces
    
    
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"locationName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        NSExpression *locationNameEx = [NSExpression expressionForKeyPath:@"notes"];
        NSExpression *locationEx = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *predicate = [NSComparisonPredicate
                                  predicateWithLeftExpression:locationNameEx
                                  rightExpression:locationEx
                                  modifier:NSDirectPredicateModifier
                                  type:NSContainsPredicateOperatorType
                                  options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:predicate];
        
        NSExpression *categoryExpression = [NSExpression expressionForKeyPath:@"category.categoryName"];
        NSExpression *categoryEx = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *catPredicate = [NSComparisonPredicate
                                     predicateWithLeftExpression:categoryExpression
                                     rightExpression:categoryEx
                                     modifier:NSDirectPredicateModifier
                                     type:NSContainsPredicateOperatorType
                                     options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:catPredicate];
        
        
        
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    // hand over the filtered results to our search results table
    SearchResultsTableVCViewController *tableController = (SearchResultsTableVCViewController *)self.searchController.searchResultsController;
    tableController.tableView.tableHeaderView = nil;
    tableController.searchResults = searchResults;
    [tableController.tableView reloadData];
}

#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}



@end
