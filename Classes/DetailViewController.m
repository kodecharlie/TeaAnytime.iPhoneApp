//
//  DetailViewController.m
//  TeaAnytime
//
//  Created by Kode Charlie on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Tea.h"

@interface DetailViewController ()
{
    // Container for rating_k UIImageViews.
    NSArray *leaves;
    NSNumber *rating;
}

@property (nonatomic, strong) NSArray *leaves;
@property (nonatomic, strong) NSNumber *rating;

- (void)configureView;
- (void)setLeafRatings:(Tea *)curTea;

@end

@implementation DetailViewController

@synthesize rating1 = _rating1;
@synthesize rating2 = _rating2;
@synthesize rating3 = _rating3;
@synthesize rating4 = _rating4;
@synthesize rating5 = _rating5;

@synthesize leaves;
@synthesize rating;

@synthesize teaLeaves = _teaLeaves;
@synthesize teaDesc = _teaDesc;
@synthesize detailItem = _detailItem;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        Tea *curTea = (Tea *)self.detailItem;
        [self.navigationItem setTitle:[curTea name]];

        self.teaLeaves.image = [UIImage imageNamed:[curTea imageFileName]];
        self.teaDesc.text = [curTea desc];

        // Handle initial rating for tea.
        [self setLeafRatings:curTea];
    }
}

- (void)setLeafRatings:(Tea *)curTea {
    for (int k = 0; k < [self.leaves count]; ++k) {
        UIImageView *leaf = (UIImageView *)[self.leaves objectAtIndex:k];
        if (k < [[curTea rating] intValue]) {
            leaf.image = [UIImage imageNamed:@"green-tea-leaf.png"];
        } else {
            leaf.image = [UIImage imageNamed:@"gray-tea-leaf.png"];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leaves = [NSArray arrayWithObjects:self.rating1, self.rating2, self.rating3, self.rating4, self.rating5, nil];

	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    // Return immediately if we are outside the bbox of the leaf images used for ratings.
    CGRect bbox  = CGRectMake(_rating1.frame.origin.x,
                              _rating1.frame.origin.y,
                              _rating5.frame.origin.x + _rating5.frame.size.width - _rating1.frame.origin.x,
                              _rating1.frame.size.height);
    if (! CGRectContainsPoint(bbox, touchLocation)) return;

    int newRating = 0;
    for(int i = self.leaves.count - 1; i >= 0; i--) {
        UIImageView *imageView = [self.leaves objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x) {
            newRating = i+1;
            break;
        }
    }

    self.rating = [NSNumber numberWithInt:newRating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    Tea *curTea = (Tea *)self.detailItem;

    // Save the new rating, if it changed.
    if (self.rating != [curTea rating]) {
        [curTea setRating:self.rating];
        [self setLeafRatings:curTea];

        NSError *error;
        if (![curTea.managedObjectContext save:&error]) {
            // XXX Handle the error.
        }
    }
}

@end
