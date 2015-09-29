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
#import "IQKeyBoardManager.h"
#import "ColorCollectionViewCell.h"
#import "Categories.h"
#import "ViewController.h"
#import "DataSource.h"

@interface CategoryViewController()<UIGestureRecognizerDelegate, UITextFieldDelegate, CategoryTableViewCellDelegate, AnnotationViewDelegate>

@property (nonatomic, strong) CategoryTableViewCell *cell;
@property (nonatomic, strong) JVFloatLabeledTextField *categoryTextField;
@property (nonatomic, strong) UIView *lowerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *addCategory;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FUIButton *doneButton;
@property (nonatomic, strong) UIView *div1;
@property (nonatomic, strong) UIView *backText;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;


@end

static NSInteger selectedIndex;
static NSInteger tableSelectedIndex;

static NSString *kTagLabel = @"like_label";
static NSString *kFullTagLabel =@"like_label_full";

@implementation CategoryViewController


-(id)init
{
    self = [super init];
    
    if (self){
        
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
        if (!_addCategory){
            self.addCategory = [UILabel new];
            //            [self.backgroundView addSubview:self.addMoreCategoriesLabel];
            
        }
        if (!_imageView)
        {
            self.imageView = [[UIImageView alloc]init];
            //            [self.backgroundView addSubview:self.addImageView];
            
        }
        
        //        if (!_backTextFieldView){
        //            self.backTextFieldView = [UIView new];
        //        }
        if (!_categoryTextField)
        {
            self.categoryTextField = [[JVFloatLabeledTextField alloc]init];
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
        self.colorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.colorCollectionView.dataSource = self;
        self.colorCollectionView.delegate = self;
        self.colorCollectionView.showsHorizontalScrollIndicator = YES;
        self.colorCollectionView.userInteractionEnabled = YES;
        
        
        
        
        
        // Ititializing colors array
        self.colorArray = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
                            [UIColor emerlandColor],
                            [UIColor  peterRiverColor],
                            [UIColor amethystColor],
                            [UIColor sunflowerColor],
                            [UIColor carrotColor],
                            [UIColor alizarinColor],
                            [UIColor concreteColor], nil];
        
        self.colorArray2  =[ NSMutableArray arrayWithObjects:[UIColor greenSeaColor],
                                   [UIColor nephritisColor],
                                   [UIColor belizeHoleColor],
                                   [UIColor wisteriaColor],
                                   [UIColor tangerineColor],
                                   [UIColor pumpkinColor],
                                   [UIColor pomegranateColor],
                                   [UIColor asbestosColor],nil];
        self.category =[NSDictionary new];
        self.categoriesCreated =[NSMutableArray new];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(barButtonItemDonePressed:)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        //INITIALIZE A BUTTON ON THE NAVIGATION BAR
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //   self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]};
    self.navigationItem.title = @"Create a new category!";
    
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
    self.state = CategoriesViewControllerShowView;
    [self.colorCollectionView registerClass:[ColorCollectionViewCell class] forCellWithReuseIdentifier:@"ColorCell"];
    
    self.colorCollectionView.backgroundColor = [UIColor whiteColor];
    
    
    
}


-(void)layoutViews {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    
    
    switch (self.state) {
            
        case CategoriesViewControllerShowView: {
            //            self.backTextFieldView = nil;
            self.containerView.backgroundColor = [UIColor silverColor];
            
            [self.containerView addSubview:self.backgroundView];
            
            [self.backgroundView addSubview:self.addCategory];
            
            [self.backgroundView addSubview:self.imageView];
            [self.addCategory setHidden:NO];
            [self.imageView setHidden:NO];
            [self.backgroundView setHidden:NO];
            //Hide the views from the other state
            [self.doneButton setHidden:YES];
            [self.categoryTextField setHidden:YES];
            [self.colorCollectionView setHidden:YES];
            
            self.lowerView = [[UIView alloc]init];
            [self.lowerView viewWithTag:2];
            self.lowerView = self.containerView;
            
            //            _bottomView = self.containerView;
            //            _containerView = _bottomView;
            
            // SET THE VIEW EQUAL TO ANOTHER VIEW SO IT CAN BE SHOWN LATER WHEN TRANSITIONING
            
            
            
        } break;
        case CategoriesViewControllerAddCategory: {
            
            [self.containerView addSubview:self.categoryTextField];
            
            [self.containerView addSubview:self.div1];
            
            [self.containerView addSubview:self.doneButton];
            [self.containerView addSubview:self.colorCollectionView];
            
            // MAKE THE ONES FROM THIS STATE VISIBLE
            [self.doneButton setHidden:NO];
            [self.categoryTextField setHidden:NO];
            [self.colorCollectionView setHidden:NO];
            
            //  HIDE THE VIEWS FROM THE OTHER STATE
            [self.addCategory setHidden:YES];
            [self.imageView setHidden:YES];
            [self.backgroundView setHidden:YES];
            
            self.backText = [[UIView alloc]init];
            [self.backText viewWithTag:1];
            self.backText = self.containerView;
            
            
            
            
        } break;
    }
    
    // FIRST VIEW
    self.imageView.frame = CGRectMake(0, 0, 44, 44);
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    CGSize labelSize = [self.addCategory sizeThatFits:maxSize];
    self.addCategory.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 8, labelSize.width, labelSize.height);
    CGFloat backgroundViewWidth = CGRectGetWidth(self.imageView.bounds) +labelSize.width;
    self.backgroundView.frame = CGRectMake((viewWidth/2)-(backgroundViewWidth/2), 88/2 -22, backgroundViewWidth , 44);
    
    
    //     SECOND VIEW SHOWN AFTER DOUBLE TAP
    //TRYING TO REMOVE VIEWS FROM SUPERVIEW, SO THAT WHEN THEY ARE CREATED AGAIN IT DOESNT COLLIDE WITH WHAT HAVE ALREADY BEEN CREATED
    
    self.categoryTextField.frame = CGRectMake(0, 0, (CGRectGetWidth(self.tableView.frame)-44), 44);
    self.div1.frame = CGRectMake(CGRectGetMaxX(self.categoryTextField.frame), 0, 0.5, 44);
    self.doneButton.frame = CGRectMake(CGRectGetMaxX(self.div1.frame), 0, 44, 44);
    //  self.colorsCollectionView.frame = CGRectMake((CGRectGetWidth(self.tableView.frame)-44)/2, 0, (CGRectGetWidth(self.tableView.frame)-44)/2, 44);
    self.colorCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryTextField.frame),viewWidth, 44);
    
    [self createTapGesture];
    
    
    
}


-(void)createBottomViews
{
    self.lowerView.backgroundColor = [UIColor silverColor];
    
    //    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

-(void)creatingBottomLabelAndImage
{
    
    self.addCategory.numberOfLines = 0;
    self.addCategory.font = [UIFont flatFontOfSize:16];
    self.addCategory.text = @"Tap to add more";
    self.addCategory.textColor = [UIColor midnightBlueColor];
    self.addCategory.translatesAutoresizingMaskIntoConstraints  = 0;
    
    UIImage *image =[UIImage imageNamed:@"add_big"];
    
    self.imageView.image = image;
    self.imageView.image = [_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.imageView setTintColor:[UIColor midnightBlueColor]];
    
    [self.backgroundView addSubview:self.addCategory];
    [self.backgroundView addSubview:self.imageView];
    
}
-(void)creatingTextField {
    self.categoryTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Category", @"POI name")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    self.categoryTextField.font =[UIFont flatFontOfSize:16];
    self.categoryTextField.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.categoryTextField.floatingLabelTextColor = [UIColor pumpkinColor];
    self.categoryTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.categoryTextField.backgroundColor = [UIColor whiteColor];
    
    
    
    
}

-(void)createDoneButtonAndDiv1
{
    
    self.div1.backgroundColor = [UIColor silverColor];
    
    [self.doneButton setImage:[UIImage imageNamed:@"plus_math"] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor whiteColor];
    self.doneButton.shadowColor = [UIColor silverColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
}







-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.colorCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake( 44, 44);
    
    
}
#pragma mark - Overrides

-(void)setState:(CategoriesViewControllerState)state animated:(BOOL)animated
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
-(void)setState:(CategoriesViewControllerState)state {
    [self setState:state animated:NO];
    
}

#pragma mark TagGesture
-(void)createTapGesture {
    
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped:)];
    self.tapGR.delegate = self;
    self.tapGR.numberOfTapsRequired = 1;
    self.tapGR.numberOfTouchesRequired = 1;
    
    [self.lowerView addGestureRecognizer:self.tapGR];
    [self.imageView addGestureRecognizer:self.tapGR];
    [self.addCategory addGestureRecognizer:self.tapGR];
    [self.backgroundView addGestureRecognizer:self.tapGR];
    
    
}




-(void)bottomViewTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"Tap was actually fired");
    
    // call helper function
    [self animatingAView:sender.view toAnother:[self.backText viewWithTag:1] forState:CategoriesViewControllerAddCategory flipFromTop:YES];
    
    //remove other subviews of self.containerview
    [self.imageView removeFromSuperview];
    [self.addCategory removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    
    
}
// Helper function
-(void)animatingAView:(UIView *)view toAnother:(UIView *)anotherView forState:(CategoriesViewControllerState)state flipFromTop:(BOOL)flip
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


#pragma mark UIButton action
-(void)doneButtonPressed:(UIButton *)sender
{
    // Checking to see if there are any colors chosen or if there are any text written
    if (self.categoryTextField.text.length >0 && self.pickedCategoryColor && _pickedCategoryColor !=nil)
    {
        // call delegate method
        
        
        
        // call helper function
        [self animatingAView:self.doneButton toAnother:[self.lowerView viewWithTag:2] forState:CategoriesViewControllerShowView flipFromTop:NO];
        
        
        //remove other subviews of self.containervie
        [self.addCategory removeFromSuperview ];
        [self.div1 removeFromSuperview];
        [self.doneButton removeFromSuperview];
        [self.colorCollectionView removeFromSuperview];
        
        // create a temporary dictionary
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        [tempDic setObject:self.categoryTextField.text forKey:@"categoryName"];
        [tempDic setObject:self.pickedCategoryColor forKey:@"categoryColor"];
        
        
        //        [tempDic setObject:0 forKey:@"selected"];
        // make temporary dictionary equal to categories dictionary
        self.category = tempDic;
        
        
        // Remove colors from array so they cant be repeated
        [self.colorArray removeObject:self.colorArray[selectedIndex]];
        [self.colorArray2 removeObject:self.colorArray2[selectedIndex]];
        
        // pass categories dictionaries as parameters of the BLCCategories object
        Categories *categories = [self categoryInitializer:self.category];
        [[DataSource sharedInstance] addCategory:categories];
        
        // add to list all the objects created
        [self.categoriesCreated addObject:categories];
        NSLog(@"self.categoriesCreted %@", self.categoriesCreated);
        
        [self.tableView reloadData];
        
        // reload and adjust tge data
        self.categoryTextField.text = @"";
        self.pickedCategoryColor = nil;
        //        self.categoryChosenColor = nil;
        
    }
    else{
        [self animatingAView:self.doneButton toAnother:[self.lowerView viewWithTag:2] forState:CategoriesViewControllerShowView flipFromTop:NO];
    }
}

-(Categories *)categoryInitializer:(NSDictionary *)dictionary {
    
    Categories *category = [[Categories alloc] iniWithDictionary:dictionary];
    return category;
}


-(void)barButtonItemDonePressed:(id)sender
{
    if (_categoriesPicked){
        //
        //
        //    if (self.mapVC.comingFromAddAnnotationState)
        //    {
        //    NSLog(@"selected Cell content View[-1]---[ %@ ]----", _selectedCell[0] );
        
        Categories *categories = _categoriesPicked[0];
        NSLog(@"selected Categories---[ %@ ]----", _categoriesPicked);
        [self.delegate category:categories];
        [self.delegate controllerDidDismiss:self];
        
        
    } else {
        [self.delegate controllerDidDismiss:self];
        
    }
}




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
    
    
    return [DataSource sharedInstance].category.count;
    
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
    
    Categories *categories = [DataSource sharedInstance].category[indexPath.row];
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.categoryColor];
    [cell.tagIV setTintColor:categories.categoryColor];
    [cell.tagIVFullView setHidden:YES];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    cell.delegate = self;
    Categories *categories = [DataSource sharedInstance].category[indexPath.row];
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.categoryColor];
    [cell.tagIV setHidden:YES];
    [cell.tagIVFullView setHidden:NO];
    [cell.tagIVFullView setTintColor:categories.categoryColor];
    
    self.cellSelected = [NSMutableArray array];
    [self.cellSelected addObject:cell.tagIVFullView];
    self.categoriesPicked = [NSMutableArray array];
    [self.categoriesPicked addObject:categories];
    [self.delegate didCompleteWithImageView:cell.tagIVFullView];
    
    //    selectedIndex = indexPath.row;
    //    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath ];
    cell.delegate = self;
    Categories *categories = [DataSource sharedInstance].category[indexPath.row];
    cell.categoryLabel.attributedText = [self categoryLabelAttributedStringForString:categories.categoryName andColor:categories.categoryColor];
    [cell.tagIVFullView setHidden:YES];
    
    [cell.tagIV setHidden:NO];
    
    [cell.tagIV setTintColor:categories.categoryColor];
    [self.cellSelected removeObject:cell.tagIVFullView];
    [self.categoriesPicked removeObject:categories];
    //    [self.tableView reloadData];
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    // RETURN 44 FOR NOW
    return 44;
    
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Categories *category = [DataSource sharedInstance].category[indexPath.row];
        NSLog(@"ALL CATEGORIES BEFORE DELETING = %@",[DataSource sharedInstance].category);
        
        [[DataSource sharedInstance] removeCategory:category];
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        NSLog(@"ALL CATEGORIES AFTER DELETING = %@",[DataSource sharedInstance].category);
        
        
    }
}


#pragma mark - UICollectionView delegate and data source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorArray.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ColorCollectionViewCell* colorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    
    
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.colorCollectionView.collectionViewLayout;
    
    colorCell.colorCollectionView.backgroundColor = self.colorArray[indexPath.row];
    
    colorCell.specificSize = flowLayout.itemSize.width;
    [colorCell.imageView setHidden:YES];
    
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
    self.pickedCategoryColor = self.colorArray2[indexPath.row]; ;
    
    
    [colorCell.imageView setHidden:NO];
    
    
    [colorCell setNeedsDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    ColorCollectionViewCell *colorCell = (ColorCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Set the index to an invalid value so that the cells get deselected
    colorCell.colorCollectionView.backgroundColor = self.colorArray[indexPath.row];
    [colorCell.imageView setHidden:YES];
    
    [colorCell setNeedsDisplay];
    
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
