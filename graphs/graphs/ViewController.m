//
//  ViewController.m
//  graphs
//
//  Created by Abel Sánchez Custodio on 19/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import "ViewController.h"

#import "ASCGraphView.h"


@interface ViewController ()
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet ASCGraphView *firstGraphView;
@property (weak, nonatomic) IBOutlet ASCGraphView *secondGraphView;
@property (weak, nonatomic) IBOutlet ASCGraphView *thirdGraphView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthGraphViews;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLayouts:self.view.bounds.size.width];
    
//    self.firstGraphView.iGraphViewType = ASCGraphViewTypeHorizontalFatBar;
//    self.firstGraphView.information = @[@{kGraphTitle : @"First value", kGraphValue : [NSNumber numberWithFloat:40.f], kGraphColor : @"#00FFA8", kGraphMaxValue : [NSNumber numberWithFloat:250.f]},
//                                        @{kGraphTitle : @"Second value", kGraphValue : [NSNumber numberWithFloat:100.f], kGraphColor : @"#00FFA8", kGraphMaxValue : [NSNumber numberWithFloat:250.f]},
//                                        @{kGraphTitle : @"Third value", kGraphValue : [NSNumber numberWithFloat:250.f], kGraphColor : @"#ffb745", kGraphMaxValue : [NSNumber numberWithFloat:250.f]}];
    
//    [self checkViewShowns:self.scrollView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self updateLayouts:size.width];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Private Methods

- (void)updateLayouts:(CGFloat)width
{
    self.widthGraphViews.constant = width - 40.f;
    
    [self.firstGraphView layoutIfNeeded];
    [self.secondGraphView layoutIfNeeded];
    [self.thirdGraphView layoutIfNeeded];
    
    [self.view layoutIfNeeded];
    
    [self checkViewShowns:self.scrollView];
}

#pragma mark - DELEGATES

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkViewShowns:scrollView];
}

- (void)checkViewShowns:(UIScrollView *)scrollView
{
    BOOL firstGraphViewIsShown = CGRectIntersectsRect(scrollView.bounds, self.firstGraphView.frame);
    
    if (firstGraphViewIsShown)
    {
        if (!self.firstGraphView.animationDone
            && !self.firstGraphView.animationProgress)
        {
            [self.firstGraphView reloadDataAnimated:YES];
        }
    }
    else
    {
        self.firstGraphView.animationDone = NO;
    }
    
    BOOL secondGraphViewIsShown = CGRectIntersectsRect(scrollView.bounds, self.secondGraphView.frame);
    
    if (secondGraphViewIsShown)
    {
        if (!self.secondGraphView.animationDone
            && !self.secondGraphView.animationProgress)
        {
            [self.secondGraphView reloadDataAnimated:YES];
        }
    }
    else
    {
        self.secondGraphView.animationDone = NO;
    }
    
    BOOL thirdGraphViewIsShown = CGRectIntersectsRect(scrollView.bounds, self.thirdGraphView.frame);
    
    if (thirdGraphViewIsShown)
    {
        if (!self.thirdGraphView.animationDone
            && !self.thirdGraphView.animationProgress)
        {
            [self.thirdGraphView reloadDataAnimated:YES];
        }
    }
    else
    {
        self.thirdGraphView.animationDone = NO;
    }
}

@end
