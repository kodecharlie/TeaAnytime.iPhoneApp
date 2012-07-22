//
//  TeaCell.h
//  TeaAnytime
//
//  Created by Kode Charlie on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeaCell : UITableViewCell
{
    UIImageView *leavesImage;
    UILabel *name;
    UILabel *group;
    UILabel *rating;
}

@property (nonatomic, retain) IBOutlet UIImageView *leavesImage;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *group;
@property (nonatomic, retain) IBOutlet UILabel *rating;

@end
