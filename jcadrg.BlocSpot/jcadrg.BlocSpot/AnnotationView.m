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


@interface AnnotationView() <UITextFieldDelegate, UITextViewDelegate, CategoryTableViewCellDelegate>

@property(nonatomic, strong) NSLayoutConstraint *tagWidth;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) JVFloatLabeledTextField *titleTF;
@property(nonatomic, strong) JVFloatLabeledTextView *descriptionTV;
@property(nonatomic, strong) UIView *div1;
@property(nonatomic, strong) UIView *div2;
@property(nonatomic, strong) UIView *div3;

@property(nonatomic, strong) IQKeyboardManager *keyboardManager;
@property(nonatomic, strong) NSString *tagTitle;

@property(nonatomic, strong) UIColor *labelColor;
//@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSDictionary *metrics;

//@property(nonatomic, strong) UIView *categoryView;
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UIImageView *categoryIV;
@property(nonatomic, strong) UILabel *categoryLabel;

//@property(nonatomic, strong) UITapGestureRecognizer *tapGR;


@end

UIColor *labelColor;


@implementation AnnotationView

+(void) load{
    labelColor = [UIColor midnightBlueColor];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAllObjects];
        [self createTopView];
        [self creatingTextField];
        [self createTextView];
        [self createDoneButton];
        [self creatingCategoryView];
        [self addCategoryButton];
        [self createConstraints];
        
        self.keyboardManager = [IQKeyboardManager sharedManager];
        self.keyboardManager.keyboardDistanceFromTextField = 4;
        self.keyboardManager.canAdjustTextView = YES;
        self.keyboardManager.shouldResignOnTouchOutside =YES;
    }
    return self;
}

-(void)initializeAllObjects {
    self.titleTF = [[JVFloatLabeledTextField alloc]init];
    
    self.descriptionTV = [[JVFloatLabeledTextView alloc]init];
    
    
    self.doneButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.categoryButton = [FUIButton buttonWithType:UIButtonTypeCustom];
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];
    
    self.div1 = [UIView new];
    self.div2 = [UIView new];
    
    self.div3 = [UIView new];
    
    self.categoryView = [UIView new];
    self.categoryIV = [[UIImageView alloc]init];
    self.categoryLabel = [[UILabel alloc]init];
    self.backView = [UIView new];

    
    
}

-(void)createTopView
{
    self.topView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.attributedText = [self titleLabelString];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryView.userInteractionEnabled = NO;
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)creatingTextField {
    
    
    self.titleTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"  Location Name", @"String naming Point of Interest")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.titleTF.font =[UIFont flatFontOfSize:14];
    self.titleTF.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.titleTF.floatingLabelTextColor = labelColor;
    self.titleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleTF.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleTF];
    
    self.div1.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div1];
    self.titleTF.translatesAutoresizingMaskIntoConstraints = NO;
    self.div1.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

-(void)creatingCategoryView{
    self.backView.backgroundColor = [UIColor clearColor];
    
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryIV.image = [UIImage imageNamed:@"plus_math"];
    self.categoryIV.image = [_categoryIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.categoryIV setTintColor:[UIColor midnightBlueColor]];
    
    self.categoryLabel.numberOfLines = 0;
    self.categoryLabel.font = [UIFont flatFontOfSize:14];
    self.categoryLabel.text = @"Category";
    self.categoryLabel.textColor = [UIColor midnightBlueColor];
    [self addSubview:self.categoryView];
    [self.categoryView addSubview:self.backView];
    [self.backView addSubview:self.categoryIV];
    [self.backView addSubview:self.categoryLabel ];
    
    self.categoryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryIV.translatesAutoresizingMaskIntoConstraints= NO;
    self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryView.userInteractionEnabled = NO;
    
    self.div3.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div3];
    self.div3.translatesAutoresizingMaskIntoConstraints =NO;
    
    
    
}



-(void)createTextView  {
    self.descriptionTV = [[JVFloatLabeledTextView alloc] init];
    self.descriptionTV.placeholder = NSLocalizedString(@"  Description", @"");
    self.descriptionTV.placeholderTextColor = [UIColor darkGrayColor];
    self.descriptionTV.font = [UIFont flatFontOfSize:14];
    self.descriptionTV.floatingLabel.font = [UIFont flatFontOfSize:11];
    self.descriptionTV.floatingLabelTextColor = labelColor;
    [self addSubview:self.descriptionTV];
    
    self.descriptionTV.delegate = self;
    self.div2.backgroundColor = [UIColor silverColor];
    [self addSubview:self.div2];
    self.descriptionTV.translatesAutoresizingMaskIntoConstraints = NO;
    self.div2.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
}


-(void)createDoneButton {
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor midnightBlueColor];
    self.doneButton.shadowColor = [UIColor wetAsphaltColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
    self.doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:14];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor silverColor] forState:UIControlStateHighlighted];
    [self addSubview:self.doneButton];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}


/*-(void)createTapGesture {
    
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapGR.delegate = self;
    self.tapGR.numberOfTapsRequired = 1;
    [self.categoryView addGestureRecognizer:self.tapGR];
    [self.backView addGestureRecognizer:self.tapGR];
    [self.categoryIV addGestureRecognizer:self.tapGR];
    [self.categoryLabel addGestureRecognizer:self.tapGR];
    
}*/

-(void) addCategoryButton{
    
    [self.categoryButton addTarget:self
                            action:@selector(addCategoryButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    self.categoryButton.buttonColor = [UIColor cloudsColor];
    self.categoryButton.shadowColor = [UIColor silverColor];
    self.categoryButton.shadowHeight = 1.0f;
    self.categoryButton.cornerRadius = 3.0f;
    self.categoryButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.categoryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.categoryButton setTitleColor:[UIColor silverColor] forState:UIControlStateHighlighted];
    
    [self addSubview:self.categoryButton];
    [self.categoryButton addSubview:self.categoryView];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    

}


#pragma mark Attributed Strings



-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = NSLocalizedString(@"Point of Interest", @"title to the topview");
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:18]}];
    
    return mutAttString;
    
}

-(NSAttributedString *)titleLabelStringWithCategory:(NSString *)categoryString withColor:(UIColor *)color{
    NSString *string = [categoryString uppercaseString];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                                attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutableAttributedString;
}

// Creating  auto layout constraints for each view

-(void)createConstraints  {
    
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleTF, _descriptionTV, _doneButton, _div1, _div2,_div3, _categoryView,_categoryIV, _categoryLabel,_backView  ,_topView, _titleLabel,_categoryButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                                                 options:kNilOptions
                                                                 metrics:self.metrics
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleTF]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div1]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionTV]|"
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(==44)][_div3(==0.5)][_titleTF(==44)][_div1(==0.5)][_descriptionTV(==100)][_div2(==0.5)][_categoryButton(==44)][_doneButton(==44)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_div3(==0.5)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self.categoryButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryView]|"
                                                                     options:kNilOptions
                                                                     metrics:nil
                                                                       views:viewDictionary]];
    
        [self.categoryButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryView]"
                                                                                  options:kNilOptions
                                                                                  metrics:nil
                                                                                    views:viewDictionary]];

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
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryIV]-[_categoryLabel]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryIV]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewDictionary]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryLabel]|"
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
    _poi.locationName = _titleTF.text;
    _poi.note = _descriptionTV.text;
    //_POI.category = [_tagsControl.tags lastObject];
    _poi.category =_category;
    
    
}



#pragma mark UIbutton actions

-(void)doneButtonPressed:(FUIButton *)sender {
    [self.delegate customView:self
           didPressDoneButton:self.doneButton
                withTitleText:self.titleTF.text
          withDescriptionText:self.descriptionTV.text];
    
    self.titleTF.text = @"";
    self.descriptionTV.text =@"";
}



#pragma mark UITapGestureRecognizer action

/*-(void)tapFired:(UITapGestureRecognizer *)sender
{
    
    //TO DO : present the table view from the top down representing current categories and the opportunity to create more
}*/

-(void) addCategoryButtonPressed:(FUIButton*)sender{
    [self.delegate customViewDidPressAddCategoryView:self];
}


#pragma mark UITextViewDelegate UITextFieldDelegate

//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self.titleField becomeFirstResponder];
//    [self.tagsControl becomeFirstResponder];
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    [self.descriptionTextView becomeFirstResponder];
//}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.


@end
