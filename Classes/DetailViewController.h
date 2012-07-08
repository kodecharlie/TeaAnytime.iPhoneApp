//
//  DetailViewController.h
//  TeaAnytime
//
//  Created by Kode Charlie on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    // Ratings.
    UIImageView *rating1;
    UIImageView *rating2;
    UIImageView *rating3;
    UIImageView *rating4;
    UIImageView *rating5;

    UIImageView *teaLeaves;
    UITextView *teaDesc;
}

@property (strong, nonatomic) IBOutlet UIImageView *rating1;
@property (strong, nonatomic) IBOutlet UIImageView *rating2;
@property (strong, nonatomic) IBOutlet UIImageView *rating3;
@property (strong, nonatomic) IBOutlet UIImageView *rating4;
@property (strong, nonatomic) IBOutlet UIImageView *rating5;

@property (strong, nonatomic) IBOutlet UIImageView *teaLeaves;
@property (strong, nonatomic) IBOutlet UITextView *teaDesc;

@property (strong, nonatomic) id detailItem;

@end
