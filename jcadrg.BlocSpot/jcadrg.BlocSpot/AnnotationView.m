//
//  AnnotationView.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "AnnotationView.h"
#import "IQKeyboardManager.h"
#import "JVFloatLabeledTextView.h"
#import "JVFloatLabeledTextField.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"


@interface AnnotationView() <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSLayoutConstraint *tagsControlWidth;

@property (nonatomic, strong) JVFloatLabeledTextField *titleField;
@property (nonatomic, strong) JVFloatLabeledTextView *descriptionTextView;
@property (nonatomic, strong) IQKeyboardManager *keyboardManager;

@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) UIView *div1;
@property (nonatomic, strong) UIView *div2;
@property (nonatomic, strong) UIView *div3;

@property (nonatomic, strong) UIColor *floatingLabelColor;


@property (nonatomic, strong) NSDictionary *metrics;



@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *addCategoryImageView;
@property (nonatomic, strong) UILabel *addCategoryLabel;




// CREATE A BUTTON AND ADD THE CATEGORY VIEW AS ITS SUBVIEW
// USE ITS ACTION TO CALL THE DELEGATE







@end

UIColor *floatingLabelColor ;


@implementation AnnotationView


+(void)load {
    floatingLabelColor = [UIColor brownColor];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAllObjects];
        [self createTopView];
        [self creatingTextField];
        [self createTextView];
        [self creadeDoneButton];
        [self creatingCategoryView];
        [self createCategoryButton];
        
        [self createConstraints];
        
        self.keyboardManager = [IQKeyboardManager sharedManager];
        self.keyboardManager.keyboardDistanceFromTextField = 4;
        self.keyboardManager.canAdjustTextView = YES;
        self.keyboardManager.shouldResignOnTouchOutside =YES;
        
    }
    return self;
}

-(void)initializeAllObjects {
    self.titleField = [[JVFloatLabeledTextField alloc]init];
    
    self.descriptionTextView = [[JVFloatLabeledTextView alloc]init];
    
    
    
    // ARRAY STORING ALL THE COLORS LATER TO BE AVAILABLE FOR THE USER
    
    //    NSMutableArray *colorsArray = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
    //                                   [UIColor emerlandColor],
    //                                   [UIColor  peterRiverColor],
    //                                   [UIColor amethystColor],
    //                                   [UIColor sunflowerColor],
    //                                   [UIColor carrotColor],
    //                                   [UIColor alizarinColor],
    //                                   [UIColor concreteColor], nil];
    
    
    
    self.doneButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];
    
    self.div1 = [UIView new];
    self.div2 = [UIView new];
    
    self.div3 = [UIView new];
    
    self.categoryView = [UIView new];
    self.addCategoryImageView = [[UIImageView alloc]init];
    self.addCategoryLabel = [[UILabel alloc]init];
    self.backView = [UIView new];
    self.categoryButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    
    
}


-(void)createTopView
{
    self.topView.backgroundColor = [UIColor cloudsColor];
    self.titleLabel.attributedText = [self titleLabelString];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)creatingTextField {
    
    
    self.titleField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Place Name", @"String naming Point of Interest")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.titleField.font =[UIFont flatFontOfSize:16];
    self.titleField.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.backgroundColor = [UIColor cloudsColor];
    [self addSubview:self.titleField];
    
    self.div1.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div1];
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;
    self.div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

-(void)creatingCategoryView{
    self.backView.backgroundColor = [UIColor clearColor];
    
    self.categoryView.backgroundColor = [UIColor cloudsColor];
    self.addCategoryImageView.image = [UIImage imageNamed:@"math_plus"];
    self.addCategoryImageView.image = [_addCategoryImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.addCategoryImageView setTintColor:[UIColor midnightBlueColor]];
    
    self.addCategoryLabel.numberOfLines = 0;
    self.addCategoryLabel.font = [UIFont flatFontOfSize:16];
    self.addCategoryLabel.text = @"Category";
    self.addCategoryLabel.textColor = [UIColor midnightBlueColor];
    [self addSubview:self.categoryView];
    [self.categoryView addSubview:self.backView];
    [self.backView addSubview:self.addCategoryImageView];
    [self.backView addSubview:self.addCategoryLabel ];
    
    self.categoryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addCategoryImageView.translatesAutoresizingMaskIntoConstraints= NO;
    self.addCategoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryView.userInteractionEnabled = NO;
    
    self.div3.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div3];
    self.div3.translatesAutoresizingMaskIntoConstraints =NO;
    
    
}



-(void)createTextView  {
    self.descriptionTextView = [[JVFloatLabeledTextView alloc] init];
    self.descriptionTextView.placeholder = NSLocalizedString(@"  Description", @"");
    self.descriptionTextView.placeholderTextColor = [UIColor darkGrayColor];
    self.descriptionTextView.font = [UIFont flatFontOfSize:16];
    self.descriptionTextView.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.descriptionTextView.floatingLabelTextColor = floatingLabelColor;
    [self addSubview:self.descriptionTextView];
    
    self.descriptionTextView.delegate = self;
    self.div2.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div2];
    self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.div2.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
}


-(void)creadeDoneButton {
    [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.doneButton.buttonColor = [UIColor midnightBlueColor];
    self.doneButton.shadowColor = [UIColor wetAsphaltColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
    self.doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor silverColor] forState:UIControlStateHighlighted];
    [self addSubview:self.doneButton];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}


-(void)createCategoryButton {
    
    [self.categoryButton addTarget:self action:@selector(addCategoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.categoryButton.buttonColor = [UIColor cloudsColor];
    self.categoryButton.shadowColor = [UIColor silverColor];
    self.categoryButton.shadowHeight = 3.0f;
    self.categoryButton .cornerRadius = 6.0f;
    self.categoryButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.categoryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.categoryButton setTitleColor:[UIColor silverColor] forState:UIControlStateHighlighted];
    [self addSubview:self.categoryButton];
    [self.categoryButton addSubview:self.categoryView];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
}


#pragma mark Attributed Strings



-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = NSLocalizedString(@"Create a BlocSpot", @"title to the topview");
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
    
}

-(NSAttributedString *)titleLabelStringWithCategory:(NSString *)categoryString withColor:(UIColor *)color  {
    
    NSString *baseString = [categoryString uppercaseString];
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
    
}

// Creating  auto layout constraints for each view

-(void)createConstraints  {
    
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleField, _descriptionTextView, _doneButton, _div1, _div2,_div3, _categoryButton,_addCategoryImageView, _addCategoryLabel,_backView  ,_topView, _titleLabel , _categoryView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                                                 options:kNilOptions
                                                                 metrics:self.metrics
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleField]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div1]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionTextView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div2]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryButton]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div3]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_doneButton]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(==44)][_div3(==0.5)][_titleField(==44)][_div1(==0.5)][_descriptionTextView(==100)][_div2(==0.5)][_categoryButton(==44)][_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_div3(==0.5)][_titleField(==44)][_div1(==0.5)][_descriptionTextView(==100)][_div2(==0.5)][_categoryButton(==44)]-[_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    //    [self.categoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backView]|"
    //                                                                 options:kNilOptions
    //                                                                 metrics:nil
    //                                                                   views:viewDictionary]];
    //    [self.categoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backView]"
    //                                                                              options:kNilOptions
    //                                                                              metrics:nil
    //                                                                                views:viewDictionary]];
    [self.categoryView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_backView
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.categoryView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_backView
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.categoryView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addCategoryImageView]-[_addCategoryLabel]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addCategoryImageView]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addCategoryLabel]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];
    [self.categoryButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryView]|"
                                                                                options:kNilOptions
                                                                                metrics:nil
                                                                                  views:viewDictionary]];
    [self.categoryButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryView]|"
                                                                                options:kNilOptions
                                                                                metrics:nil
                                                                                  views:viewDictionary]];
    
    
    
    
}


-(void)layoutSubviews  {
    
    [super layoutSubviews];
    
    
}
-(void)setPOI:(POI *)POI
{
    _poi = POI;
    _poi.locationName = _titleField.text;
    _poi.note = _descriptionTextView.text;
    _poi.category = _category;
    
}




#pragma mark UIbutton actions

-(void)doneButtonPressed:(FUIButton *)sender {
    [self.delegate customView:self
           didPressDoneButton:self.doneButton
                withTitleText:self.titleField.text
          withDescriptionText:self.descriptionTextView.text
     //                 withCategory:self.category
     ];
    self.titleField.text = @"";
    self.descriptionTextView.text = @"";
    
}

#pragma mark UITapGestureRecognizer action

-(void)addCategoryButtonPressed:(FUIButton *)sender
{
    
    [self.delegate customViewDidPressAddCategoriesView:self];
    
}






//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self.titleField becomeFirstResponder];
//    [self.tagsControl becomeFirstResponder];
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    [self.descriptionTextView becomeFirstResponder];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
