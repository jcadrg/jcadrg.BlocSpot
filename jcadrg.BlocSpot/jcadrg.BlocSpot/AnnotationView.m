//
//  AnnotationView.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "AnnotationView.h"

@interface AnnotationView() <UITextFieldDelegate, UITextViewDelegate, AnnotationViewDelegate>

@property(nonatomic, strong) NSLayoutConstraint *tagWidth;

@end


@implementation AnnotationView

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initObjects];
        [self initTextField];
        [self initTextView];
        [self addDoneButton];
        [self addSubviews];
        [self createConstraints];
    }
    
    return self;
}


-(void) initObjects{
    self.titleText = [[FUITextField alloc] init];
    self.descriptionText = [[UITextView alloc] init];
    
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:[UIColor turquoiseColor],
                              [UIColor emerlandColor],
                              [UIColor cloudsColor],
                              [UIColor amethystColor],
                              [UIColor sunflowerColor],
                              [UIColor carrotColor],
                              [UIColor alizarinColor],
                               [UIColor concreteColor], nil];
    
    self.tagView = [[UIView alloc]init];
    self.tagsControl = [[TLTagsControl alloc] init];
    self.tagsControl.mode = TLTagsControlModeEdit;
    self.doneButton = [FUIButton buttonWithType:UIButtonTypeCustom];
}

-(void) initTextField{
    self.titleText.font = [UIFont flatFontOfSize:14];
    self.titleText.backgroundColor = [UIColor clearColor];
    self.titleText.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.titleText.textFieldColor = [UIColor whiteColor];
    self.titleText.borderColor = [UIColor turquoiseColor];
    self.titleText.borderWidth = 2.0f;
    self.titleText.cornerRadius = 3.0f;
}

-(void) initTextView{
    self.descriptionText.delegate = self;
    self.descriptionText.layer.borderColor = [UIColor colorWithRed:0.427 green:0.034 blue:0.010 alpha:1].CGColor;
    [self.descriptionText setFont:[UIFont flatFontOfSize:12]];
}

-(void) addDoneButton{
    [self.doneButton setAttributedTitle:[self doneButtonAttributedString] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonPressedTapFired:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton.buttonColor = [UIColor turquoiseColor];
    self.doneButton.shadowColor = [UIColor greenSeaColor];
    self.doneButton.shadowHeight = 3.0f;
    self.doneButton.cornerRadius = 6.0f;
    self.doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:14];
    [self.doneButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateHighlighted];
}

-(void) addSubviews{
    [self addSubview:self.titleText];
    [self addSubview:self.descriptionText];
    [self addSubview:self.tagsControl];
    [self addSubview:self.doneButton];
    self.titleText.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.descriptionText.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tagsControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - Done Button attributed text methods

-(NSAttributedString *)doneButtonAttributedString{
    NSString *string = @"Done";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    return attributedString;
}

-(void) setTagsControl:(TLTagsControl *)tagsControl{
    _tagsControl = tagsControl;
}

-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleText, _descriptionText, _tagsControl, _doneButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleText]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionText]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagsControl]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleText(==42)][_descriptionText(==100)][_tagsControl(==42)]-[_doneButton(==42)]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    self.tagWidth = [NSLayoutConstraint constraintWithItem:_tagsControl
                                                 attribute:NSLayoutAttributeWidth
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:nil
                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                multiplier:1
                                                  constant:100];
    
    [self addConstraint:self.tagWidth];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tagWidth.constant = CGRectGetWidth(self.titleText.frame);
    
}

-(void) setPoi:(POI *)poi{
    _poi = poi;
    _poi.locationName = _titleText.text;
    _poi.note = _descriptionText.text;
    _poi.category = [_tagsControl.tags lastObject];
    
}


#pragma mark - Button tap acion

-(void) doneButtonPressedTapFired:(FUIButton *) sender{
    [self.delegate customView:self
           didPressDoneButton:self.doneButton
                withTitleText:self.titleText.text
          withDescriptionText:self.descriptionText.text
                      withTag:[self.tagsControl.tags lastObject]];
}

@end
