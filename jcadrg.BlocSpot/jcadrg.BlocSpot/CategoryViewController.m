//
//  CategoryViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CategoryViewController.h"
#import "FlatUIKit.h"
#import "JVFloatLabeledTextField.h"
#import "CategoryTableViewCell.h"
#import "IQKeyboardManager.h"
#import "ColorCollectionViewCell.h"
#import "Categories.h"

#import "ViewController.h"
#import "DataSource.h"





@interface CategoryViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, CategoryTableViewCellDelegate>


@property (nonatomic, strong) CategoryTableViewCell *cell;

@property (nonatomic, strong) JVFloatLabeledTextField *addCategoryField;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *addMoreCategoriesLabel;

@property (nonatomic, strong) UIImageView *addImageView;


@property (nonatomic, strong) FUIButton *doneButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIView *div1;

@property (nonatomic, strong) UIView *backTextFieldView;

@property (nonatomic, strong) UIView *containerView;


@property (nonatomic, strong) UIColor *similarChosenColor2;



@end

static NSInteger selectedIndex;
static NSInteger tableSelectedIndex;

static NSString *kTagLabel = @"heart_label";
static NSString *kFullTagLabel = @"heart_label_full";


@implementation CategoryViewController

-(id)init
{
    self = [super init];
    
    if (self){
        [[DataSource sharedInstance] addObserver:self forKeyPath:@"categories" options:0 context:nil];
        //Itnitialize all objects
        if (!_containerView)
        {
            self.containerView = [UIView new];
        }
        //        if (!_bottomView){
        //            self.bottomView = [UIView new];
        //        }
        if (!_backgroundView)
        {
            self.backgroundView = [UIView new];
            //            [self.containerView addSubview:self.backgroundView];
            
        }
        if (!_addMoreCategoriesLabel){
            self.addMoreCategoriesLabel = [UILabel new];
            //            [self.backgroundView addSubview:self.addMoreCategoriesLabel];
            
        }
        if (!_addImageView)
        {
            self.addImageView = [[UIImageView alloc]init];
            //            [self.backgroundView addSubview:self.addImageView];
            
        }
        
        //        if (!_backTextFieldView){
        //            self.backTextFieldView = [UIView new];
        //        }
        if (!_addCategoryField)
        {
            self.addCategoryField = [[JVFloatLabeledTextField alloc]init];
            //            [self.containerView addSubview:self.addCategoryField ];
            
        }
        if (!_div1)
        {
            self.div1 = [UIView new];
            //            [self.containerView addSubview:self.div1];
            
        }
        if (!_doneButton)
        {
            
            self.doneButton =[FUIButton buttonWithType:UIButtonTypeCustom];
            //            [self.containerView addSubview:self.doneButton];
            
        }
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        
        
        // initializing the flow layout , deciding the size, the direction to scroll and the min. line spacing
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(44, 64);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        
        
        // Initializing a UICollectionView frame, dataSource, delegate and if it shows an indicator
        self.colorsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.colorsCollectionView.dataSource = self;
        self.colorsCollectionView   .delegate = self;
        self.colorsCollectionView.showsHorizontalScrollIndicator = YES;
        self.colorsCollectionView.userInteractionEnabled = YES;
        
        
        
        
        
        // Ititializing colors array
        self.colorsArray = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
                            [UIColor emerlandColor],
                            [UIColor  peterRiverColor],
                            [UIColor amethystColor],
                            [UIColor sunflowerColor],
                            [UIColor carrotColor],
                            [UIColor alizarinColor],
                            [UIColor concreteColor], nil];
        
        self.colorsArraySimilar  =[ NSMutableArray arrayWithObjects:[UIColor greenSeaColor],
                                   [UIColor nephritisColor],
                                   [UIColor belizeHoleColor],
                                   [UIColor wisteriaColor],
                                   [UIColor tangerineColor],
                                   [UIColor pumpkinColor],
                                   [UIColor pomegranateColor],
                                   [UIColor asbestosColor],nil];
        self.categories =[NSMutableDictionary new];
        self.categoriesCreated =[NSMutableArray new];
        
        
        //INITIALIZE A BUTTON ON THE NAVIGATION BAR
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(barButtonItemDonePressed:)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        self.similarChosenColor2 = [UIColor new];
        
        
        
    }
    return self;
}
-(void)dealloc
{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"categories"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //   self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]};
    self.navigationItem.title = @"Create a Category";
    
    // TABLEVIEW
    if (!_tableView) {
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.userInteractionEnabled = YES;
        //self.tableView.backgroundColor = [UIColor clearColor];
        //        [self.tableView setTableHeaderView:nil];
        [self.view addSubview:self.tableView];
        
    }
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.keyboardDistanceFromTextField = 0;
    keyboardManager.canAdjustTextView = NO;
    keyboardManager.shouldResignOnTouchOutside =YES;
    [self creatingTextField];
    [self createDoneButtonAndDiv1];
    [self createBottomViews];
    [self creatingBottomLabelAndImage];
    
    
    
    [self.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:@"CategoryCell"];
    self.state = CategoryViewControllerShowView;
    [self.colorsCollectionView registerClass:[ColorCollectionViewCell class] forCellWithReuseIdentifier:@"ColorCell"];
    
    self.colorsCollectionView.backgroundColor = [UIColor cloudsColor];
    
    
    
}


-(void)layoutViews {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    
    
    switch (self.state) {
            
        case CategoryViewControllerShowView: {
            //            self.backTextFieldView = nil;
            self.containerView.backgroundColor = [UIColor silverColor];
            
            [self.containerView addSubview:self.backgroundView];
            
            [self.backgroundView addSubview:self.addMoreCategoriesLabel];
            
            [self.backgroundView addSubview:self.addImageView];
            [self.addMoreCategoriesLabel setHidden:NO];
            [self.addImageView setHidden:NO];
            [self.backgroundView setHidden:NO];
            //Hide the views from the other state
            [self.doneButton setHidden:YES];
            [self.addCategoryField setHidden:YES];
            [self.colorsCollectionView setHidden:YES];
            
            self.bottomView = [[UIView alloc]init];
            [self.bottomView viewWithTag:2];
            self.bottomView = self.containerView;
            
            //            _bottomView = self.containerView;
            //            _containerView = _bottomView;
            
            // SET THE VIEW EQUAL TO ANOTHER VIEW SO IT CAN BE SHOWN LATER WHEN TRANSITIONING
            
            
            
        } break;
        case CategoryViewControllerAddCategory: {
            
            [self.containerView addSubview:self.addCategoryField ];
            
            [self.containerView addSubview:self.div1];
            
            [self.containerView addSubview:self.doneButton];
            [self.containerView addSubview:self.colorsCollectionView];
            
            // MAKE THE ONES FROM THIS STATE VISIBLE
            [self.doneButton setHidden:NO];
            [self.addCategoryField setHidden:NO];
            [self.colorsCollectionView setHidden:NO];
            //  HIDE THE VIEWS FROM THE OTHER STATE
            [self.addMoreCategoriesLabel setHidden:YES];
            [self.addImageView setHidden:YES];
            [self.backgroundView setHidden:YES];
            
            self.backTextFieldView = [[UIView alloc]init];
            [self.backTextFieldView viewWithTag:1];
            self.backTextFieldView = self.containerView;
            
            
            
            
        } break;
    }
    
    // FIRST VIEW
    self.addImageView.frame = CGRectMake(0, 0, 44, 44);
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    CGSize labelSize = [self.addMoreCategoriesLabel sizeThatFits:maxSize];
    self.addMoreCategoriesLabel.frame = CGRectMake(CGRectGetMaxX(self.addImageView.frame), 8, labelSize.width, labelSize.height);
    CGFloat backgroundViewWidth = CGRectGetWidth(self.addImageView.bounds) +labelSize.width;
    self.backgroundView.frame = CGRectMake((viewWidth/2)-(backgroundViewWidth/2), 88/2 -22, backgroundViewWidth , 44);
    
    
    //     SECOND VIEW SHOWN AFTER DOUBLE TAP
    
    self.addCategoryField.frame = CGRectMake(0, 0, (CGRectGetWidth(self.tableView.frame)-44), 44);
    self.div1.frame = CGRectMake(CGRectGetMaxX(self.addCategoryField.frame), 0, 0.5, 44);
    self.doneButton.frame = CGRectMake(CGRectGetMaxX(self.div1.frame), 0, 44, 44);
    
    self.colorsCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.addCategoryField.frame),viewWidth, 44);
    
    [self createTapGesture];
    
    
    
}


-(void)createBottomViews
{
    self.bottomView.backgroundColor = [UIColor silverColor];
    
}

-(void)creatingBottomLabelAndImage
{
    
    self.addMoreCategoriesLabel.numberOfLines = 0;
    self.addMoreCategoriesLabel.font = [UIFont flatFontOfSize:16];
    self.addMoreCategoriesLabel.text = @"Tap to add more";
    self.addMoreCategoriesLabel.textColor = [UIColor midnightBlueColor];
    self.addMoreCategoriesLabel.translatesAutoresizingMaskIntoConstraints  = 0;
    
    UIImage *image =[UIImage imageNamed:@"plus_math"];
    
    self.addImageView.image = image;
    self.addImageView.image = [_addImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.addImageView setTintColor:[UIColor midnightBlueColor]];
    
    [self.backgroundView addSubview:self.addMoreCategoriesLabel];
    [self.backgroundView addSubview:self.addImageView];
    
}
-(void)creatingTextField {
    self.addCategoryField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Category", @"String naming Point of Interest")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    self.addCategoryField.font =[UIFont flatFontOfSize:16];
    self.addCategoryField.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.addCategoryField.floatingLabelTextColor = [UIColor pumpkinColor];
    self.addCategoryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addCategoryField.backgroundColor = [UIColor cloudsColor];
    
    
    
    
}

-(void)createDoneButtonAndDiv1
{
    
    self.div1.backgroundColor = [UIColor silverColor];
    
    [self.doneButton setImage:[UIImage imageNamed:@"plus_math"] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor cloudsColor];
    self.doneButton.shadowColor = [UIColor silverColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
}







-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.colorsCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake( 44, 44);
    
    
}
#pragma mark - Overrides

-(void)setState:(CategoryViewControllerState)state animated:(BOOL)animated
{
    _state = state;
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self layoutViews];
                         }];
        
    } else {
        [self layoutViews];
    }
    
    
}
-(void)setState:(CategoryViewControllerState)state {
    [self setState:state animated:NO];
    
}

#pragma mark TagGesture
-(void)createTapGesture {
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.numberOfTouchesRequired = 1;
    
    [self.bottomView addGestureRecognizer:self.tapGesture];
    [self.addImageView addGestureRecognizer:self.tapGesture];
    [self.addMoreCategoriesLabel addGestureRecognizer:self.tapGesture];
    [self.backgroundView addGestureRecognizer:self.tapGesture];
    
    
}

// TO DO, TO BE IMPLEMENTED O THE CELL


-(void)bottomViewTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"Tap was actually fired");
    
    // call helper function
    [self animatingAView:sender.view toAnother:[self.backTextFieldView viewWithTag:1] forState:CategoryViewControllerAddCategory flipFromTop:YES];
    
    //remove other subviews of self.containerview
    [self.addImageView removeFromSuperview];
    [self.addMoreCategoriesLabel removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    
    
}
// Helper function
-(void)animatingAView:(UIView *)view toAnother:(UIView *)anotherView forState:(CategoryViewControllerState)state flipFromTop:(BOOL)flip
{
    
    if (flip){
        [UIView transitionFromView:view
                            toView:anotherView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        completion:^(BOOL success){
                            if (success)
                            {
                                [self setState:state animated:NO];
                                
                                
                            }
                            
                        }];
    } else {
        [UIView transitionFromView:view
                            toView:anotherView
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        completion:^(BOOL success){
                            if (success)
                            {
                                [self setState:state animated:YES];
                                
                                
                            }
                            
                        }];
        
    }
    
    
}
-(UIImageView *)returnImageColoredForColor:(UIColor *)color
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"hearts_filled"];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [imageView setTintColor:color];
    
    //    chosenColor = nil;
    return imageView;
    
}

#pragma mark UIButton action
-(void)doneButtonPressed:(UIButton *)sender
{
    // Checking to see if there are any colors chosen or if there are any text written
    if (self.addCategoryField.text.length >0 && self.categoryChosenColor && _similarChosenColor2)
    {
        // call delegate method
        
        
        // call helper function
        [self animatingAView:self.doneButton
                   toAnother:[self.bottomView viewWithTag:2]
                    forState:CategoryViewControllerShowView
                 flipFromTop:NO];
        
        
        //remove other subviews of self.containervie
        [self.addCategoryField removeFromSuperview ];
        [self.div1 removeFromSuperview];
        [self.doneButton removeFromSuperview];
        [self.colorsCollectionView removeFromSuperview];
        
        
        [self.categories setObject:self.addCategoryField.text forKey:@"categoryName"];
        [self.categories setObject:self.categoryChosenColor forKey:@"categoryColor"];
        [self.categories setObject:[self returnImageColoredForColor:self.categoryChosenColor] forKey:@"categoryImage"];
        Categories *category = [[Categories alloc]initWithDictionary:self.categories];
        [[DataSource sharedInstance] addCategories:category];
        // Remove colors from array so they cant be repeated
        
        // pass categories dictionaries as parameters of the BLCCategories object
        
        
        
        
        [self.tableView reloadData];
        
        // reload and adjust tge data
        self.addCategoryField.text = @"";
        //        self.categoryChosenColor = nil;
        //        self.categoryChosenColor = nil;
        
    }
    else{
        [self animatingAView:self.doneButton toAnother:[self.bottomView viewWithTag:2] forState:CategoryViewControllerShowView flipFromTop:NO];
    }
}

-(void)barButtonItemDonePressed:(id)sender
{
    //
    //
    //    if (self.mapVC.comingFromAddAnnotationState)
    //    {
    //    NSLog(@"selected Cell content View[-1]---[ %@ ]----", _selectedCell[0] );
    
    Categories *categories = _selectedCategories[0];
    NSLog(@"CATEGORY Dictionary  ---- %@ ----", categories.pointsOfInterest);
    if (categories){
        [self.delegate category:categories];
        
        NSLog(@"self.catefories['categoryImage'] = %@", categories.categoryImage);
        
        
        
        [self.delegate controllerDidDismiss:self];
    }
    
}

#pragma mark BLCCategoryTaleViewCell
//
//-(void)didGetImageView:(UIImageView *)imageView {
//
//    self.imageViewSelected = [NSMutableArray array];
//    [self.imageViewSelected addObject:imageView];
//
//}


#pragma Attributed String

- (NSAttributedString *) categoryLabelAttributedStringForString:(NSString*)string andColor:(UIColor *)color{
    NSString *baseString = NSLocalizedString([string uppercaseString], @"Label of category");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *baseAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
    
    [baseAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
    [baseAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [baseAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return baseAttributedString;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [DataSource sharedInstance].categories.count;
    
}


- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    
    _tableView = tableView;
    
    // TO DO ADD THE FOOTER VIEW
    return _containerView;
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (section == 0){
        _tableView = tableView;
        view = _containerView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return 88;//RETURN 44 FOR NOW
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    NSLog(@"[BLCDataSource sharedInstance].categories *** %@ ***", [DataSource sharedInstance].categories);
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.color];
    [cell.tagImageView setTintColor:categories.color];
    [cell.tagImageViewFull setHidden:YES];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    cell.delegate = self;
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.color];
    [cell.tagImageView setHidden:YES];
    [cell.tagImageViewFull setHidden:NO];
    [cell.tagImageViewFull setTintColor:categories.color];
    
    //    self.selectedCell = [NSMutableArray array];
    //    [self.selectedCell addObject:cell.tagImageViewFull];
    self.selectedCategories = [NSMutableArray array];
    [self.selectedCategories addObject:categories];
    
    self.imageViewSelected = [NSMutableArray array];
    [self.imageViewSelected addObject:cell.tagImageViewFull];
    
    
    //    selectedIndex = indexPath.row;
    //    [self.tableView reloadData];
    [cell setNeedsDisplay];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    cell.delegate = self;
    Categories *categories = [DataSource sharedInstance].categories[indexPath.row];
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.color];
    [cell.tagImageViewFull setHidden:YES];
    
    [cell.tagImageView setHidden:NO];
    
    [cell.tagImageView setTintColor:categories.color];
    //    [self.selectedCell removeObject:cell.tagImageViewFull];
    [self.selectedCategories removeObject:categories];
    //    [self.imageViewSelected removeObject:cell.tagImageViewFull];
    
    //    [self.tableView reloadData];
    [cell setNeedsDisplay];
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    // RETURN 44 FOR NOW
    return 44;
    
}


// EDIT EACH CELL

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Categories *item = [DataSource sharedInstance].categories[indexPath.row];
        [[DataSource sharedInstance] deleteCategories:item];
        //        [self.tableView reloadData];
        NSLog(@"ALL CATEGORIES AFTER DELETING = %@",[DataSource sharedInstance].categories);
        
        
    }
}
#pragma mark Key-Value Observing

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"categories"]) {
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



#pragma mark - UICollectionView delegate and data source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorsArray.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ColorCollectionViewCell* colorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    
    
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.colorsCollectionView.collectionViewLayout;
    
    colorCell.colorCollectionView.backgroundColor = self.colorsArray[indexPath.row];
    
    colorCell.specificSize = flowLayout.itemSize.width;
    [colorCell.checkImageView setHidden:YES];
    
    //        [self.colorCell.colorButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    //    colorCell.selectedBackgroundView.backgroundColor = self.colorsArraySimilar[indexPath.row];
    //    colorCell.specifiedSize = flowLayout.itemSize.width;
    
    
    
    return colorCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    ColorCollectionViewCell *colorCell = (ColorCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // Set the index once user taps on a cell
    
    selectedIndex = indexPath.row;
    // Set the selection here so that selection of cell is shown to ur user immediately
    self.categoryChosenColor = self.colorsArray[indexPath.row]; ;
    
    
    [colorCell.checkImageView setHidden:NO];
    
    
    [colorCell setNeedsDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    ColorCollectionViewCell *colorCell = (ColorCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Set the index to an invalid value so that the cells get deselected
    colorCell.colorCollectionView.backgroundColor = self.colorsArraySimilar[indexPath.row];
    self.similarChosenColor2 = self.colorsArraySimilar[indexPath.row];
    [colorCell.checkImageView setHidden:YES];
    
    [colorCell setNeedsDisplay];
    
}

@end