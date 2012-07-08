//
//  Tea.h
//  TeaAnytime
//
//  Created by Kode Charlie on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tea : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * imageFileName;

@end
