//
//  ASCGraphView.m
//  graphs
//
//  Created by Abel Sánchez Custodio on 19/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import "ASCGraphView.h"


@interface ASCGraphView ()

@property (strong, nonatomic) NSMutableArray *barsView;

@end


@implementation ASCGraphView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)prepareForInterfaceBuilder
{
    [self initialize];
}

#pragma mark - Custom Accessors

- (ASCGraphViewType)graphViewType
{
    return self.iGraphViewType;
}

- (void)setSInformation:(NSString *)sInformation
{
    _sInformation = sInformation;
    
    _information = [NSArray arrayWithJSON:self.sInformation];
    
    [self buildView];
}

- (void)setInformation:(NSArray *)information
{
    _information = information;
    
    [self buildView];
}

#pragma mark - Public Methods

- (void)reloadDataAnimated:(BOOL)animated
{
    [self initialize];
    
    if (animated)
    {
        [self animatedBarsView];
    }
}

#pragma mark - Private Methods

- (void)initialize
{
    self.defaultInformation = @"";
    self.defaultGraphViewType = 0;
    
    self.clipsToBounds = YES;
    
    self.animated = YES;
    self.animationDone = NO;
    self.animationProgress = NO;
    
    [self configureInformation];
    
    [self buildView];
}

- (void)animatedBarsView
{
    for (UIView *barView in self.barsView)
    {
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            if (constraint.firstItem == barView
                && constraint.firstAttribute == NSLayoutAttributeWidth)
            {
                constraint.constant = 0.f;
            }
        }
    }
    
    [self layoutIfNeeded];
    
    for (int i = 0; i < self.barsView.count; i++)
    {
        UIView *barView = self.barsView[i];
        
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            if (constraint.firstItem == barView
                && constraint.firstAttribute == NSLayoutAttributeWidth)
            {
                constraint.constant = [self valueAtIndex:i];
            }
        }
    }
    
    __weak typeof(self) this = self;
    
    self.animationProgress = YES;
    
    [UIView animateWithDuration:1.f animations:^{
        [this layoutIfNeeded];
    } completion:^(BOOL finished) {
        this.animationProgress = NO;
        this.animationDone = YES;
    }];
}

- (void)setHeightToParent
{
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if (constraint.firstItem == self
            && constraint.firstAttribute == NSLayoutAttributeHeight)
        {
//            constraint.constant = 100.f;
        }
    }
}

- (void)buildView
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.barsView = [NSMutableArray array];
    
    switch (self.graphViewType)
    {
        case ASCGraphViewTypeHorizontalFatBar:
            [self buildHorizontalFatBar];
            break;
        case ASCGraphViewTypeHorizontalThinBar:
            [self buildHorizontalThinBar];
            break;
        case ASCGraphViewTypeMiddleBar:
            [self buildMiddleBar];
            break;
        default:
            break;
    }
    
    
}

- (void)buildHorizontalFatBar
{
    for (int i = 0; i < self.information.count; i++)
    {
        NSDictionary *dictionary = self.information[i];
        
        //title
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textColor = [UIColor blackColor];
        
        NSNumber *value = [dictionary valueForKey:kGraphValue];
        
        titleLabel.text = [NSString stringWithFormat:@"%@ %.2f", [dictionary stringForKey:kGraphTitle], [value doubleValue]];
        
        [self addSubview:titleLabel];
        
        if (i == 0)
        {
            NSMutableArray *titleConstraints = [NSMutableArray array];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleLabel sizeToFit];
            
            [titleLabel.superview addConstraints:titleConstraints];
        }
        else
        {
            UIView *previousBarView = self.barsView[i-1];
            
            NSMutableArray *titleConstraints = [NSMutableArray array];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousBarView]-20-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousBarView, titleLabel)]];
            
            [titleLabel sizeToFit];
            
            [titleLabel.superview addConstraints:titleConstraints];
        }
        
        //bar view
        
        UIView *barView = [self buildBarView:dictionary];
        
        CGFloat width = [self valueAtIndex:i];
        
        NSDictionary *metrics = @{@"width": [NSNumber numberWithFloat:width], @"height" : [NSNumber numberWithFloat:30.f]};
        
        NSMutableArray *barViewConstraints = [NSMutableArray array];
        
        [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[barView(width)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(barView)]];
        
        [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-[barView(height)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(titleLabel, barView)]];

        [barView.superview addConstraints:barViewConstraints];
        
        //separator view
        
        UIView *separatorView = [self buildSeparatorView];
        
        NSMutableArray *separatorViewConstraints = [NSMutableArray array];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separatorView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObject:[NSLayoutConstraint constraintWithItem:separatorView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:barView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0]];
        
        [separatorView.superview addConstraints:separatorViewConstraints];
    }
}

- (void)buildHorizontalThinBar
{
    for (int i = 0; i < self.information.count; i++)
    {
        NSDictionary *dictionary = self.information[i];
        
        //title
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont systemFontOfSize:13.f];
        titleLabel.textColor = [UIColor blackColor];
        
        NSNumber *value = [dictionary valueForKey:kGraphValue];
        
        titleLabel.text = [NSString stringWithFormat:@"%@ %.2f", [dictionary stringForKey:kGraphTitle], [value doubleValue]];
        
        [self addSubview:titleLabel];
        
        if (i == 0)
        {
            NSMutableArray *titleConstraints = [NSMutableArray array];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleLabel sizeToFit];
            
            [titleLabel.superview addConstraints:titleConstraints];
        }
        else
        {
            UIView *previousBarView = self.barsView[i-1];
            
            NSMutableArray *titleConstraints = [NSMutableArray array];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            
            [titleConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousBarView]-10-[titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousBarView, titleLabel)]];
            
            [titleLabel sizeToFit];
            
            [titleLabel.superview addConstraints:titleConstraints];
        }
        
        //bar view
        
        UIView *barView = [self buildBarView:dictionary];
        
        NSNumber *maxValue = [dictionary valueForKey:kGraphMaxValue];
        
        CGFloat width = ([value doubleValue] == [maxValue doubleValue]) ? self.bounds.size.width : self.bounds.size.width * [value doubleValue] / [maxValue doubleValue];
        
        NSDictionary *metrics = @{@"width": [NSNumber numberWithFloat:width], @"height" : [NSNumber numberWithFloat:15.f]};
        
        NSMutableArray *barViewConstraints = [NSMutableArray array];
        
        [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[barView(width)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(barView)]];
        
        [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-10-[barView(height)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(titleLabel, barView)]];
        
        [barView.superview addConstraints:barViewConstraints];
        
        //separator view
        
        UIView *separatorView = [self buildSeparatorView];
        
        NSMutableArray *separatorViewConstraints = [NSMutableArray array];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separatorView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObject:[NSLayoutConstraint constraintWithItem:separatorView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:barView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
        
        [separatorView.superview addConstraints:separatorViewConstraints];
    }
}

- (void)buildMiddleBar
{
    for (int i = 0; i < self.information.count; i++)
    {
        NSDictionary *dictionary = self.information[i];
        
        NSNumber *value = [dictionary valueForKey:kGraphValue];
        
        //separator view
        
        UIView *separatorView = [self buildSeparatorView];
        
        NSDictionary *metricsSeparatorView = @{@"height" : [NSNumber numberWithFloat:self.information.count * 50.f]};
        
        NSMutableArray *separatorViewConstraints = [NSMutableArray array];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separatorView(height)]" options:0 metrics:metricsSeparatorView views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorView(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
        
        [separatorViewConstraints addObject:[NSLayoutConstraint constraintWithItem:separatorView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:separatorView.superview
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:0]];
        
        [separatorView.superview addConstraints:separatorViewConstraints];
        
        //title & subtitle
        
        UILabel *valueLabel = [[UILabel alloc] init];
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        valueLabel.font = [UIFont systemFontOfSize:13.f];
        valueLabel.textColor = [UIColor blackColor];

        valueLabel.text = [NSString stringWithFormat:@"%.2f", [value doubleValue]];
        
        [self addSubview:valueLabel];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont systemFontOfSize:10.f];
        titleLabel.textColor = [UIColor blackColor];
        
        titleLabel.text = [NSString stringWithFormat:@"%@", [dictionary stringForKey:kGraphTitle]];
        
        [self addSubview:titleLabel];
        
        NSMutableArray *labelConstraints = [NSMutableArray array];
        
        //bar view
        
        UIView *barView = [self buildBarView:dictionary];
        
        CGFloat width = [self valueAtIndex:i];
        
        NSDictionary *metrics = @{@"width": [NSNumber numberWithFloat:width], @"height" : [NSNumber numberWithFloat:30.f]};
        
        NSMutableArray *barViewConstraints = [NSMutableArray array];

        if ([value doubleValue] > 0)
        {
            [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[barView(width)][separatorView]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(barView, separatorView)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorView]-5-[titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView, titleLabel)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorView]-5-[valueLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView, valueLabel)]];
        }
        else
        {
            [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorView][barView(width)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(separatorView, barView)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]-5-[separatorView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, separatorView)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[valueLabel]-5-[separatorView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(valueLabel, separatorView)]];
            
            valueLabel.textAlignment = NSTextAlignmentRight;
            titleLabel.textAlignment = NSTextAlignmentRight;
        }

        if (i == 0)
        {
            [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[barView(height)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(barView)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[valueLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(valueLabel)]];
        }
        else
        {
            UIView *previousBarView = self.barsView[i-1];
            
            [barViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousBarView]-15-[barView(height)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(previousBarView, barView)]];
            
            [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousBarView]-15-[valueLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousBarView, valueLabel)]];
        }
        
        [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[valueLabel][titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(valueLabel, titleLabel)]];
        
        [barView.superview addConstraints:barViewConstraints];
        
        [self addConstraints:labelConstraints];
    }
}

- (CGFloat)valueAtIndex:(NSInteger)index
{
    NSDictionary *dictionary = self.information[index];
    
    NSNumber *maxValue = [dictionary valueForKey:kGraphMaxValue];
    NSNumber *value = [dictionary valueForKey:kGraphValue];
    
    switch (self.graphViewType)
    {
        case ASCGraphViewTypeHorizontalFatBar:
        case ASCGraphViewTypeHorizontalThinBar:
            return ([value doubleValue] == [maxValue doubleValue]) ? self.frame.size.width : self.bounds.size.width * [value doubleValue] / [maxValue doubleValue];
        case ASCGraphViewTypeMiddleBar:
            return fabs(([value doubleValue] == [maxValue doubleValue]) ? (self.bounds.size.width / 2) - 1 : ((self.bounds.size.width / 2) - 1) * [value doubleValue] / [maxValue doubleValue]);
        default:
            return 0.f;
    }
}

#pragma mark - Configure

//Views

- (UIView *)buildBarView:(NSDictionary *)dictionary
{
    UIView *barView = [[UIView alloc] init];
    
    barView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *barViewColor = [dictionary stringForKey:kGraphColor];
    
    barView.backgroundColor = [UIColor colorWithHexString:barViewColor];
    
    [self addSubview:barView];
    
    [self.barsView addObject:barView];
    
    return barView;
}

- (UIView *)buildSeparatorView
{
    UIView *separatorView = [[UIView alloc] init];
    
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:separatorView];
    
    return separatorView;
}

- (void)configureInformation
{
    if (self.information)
    {
        _information = self.information;
    }
    else if (self.sInformation.length > 0)
    {
        _information = [NSArray arrayWithJSON:self.sInformation];
    }
}

@end
