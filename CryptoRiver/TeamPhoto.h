//  Created by Peter Sun on 9/9/22.
//  Copyright © 2022 Peter Sun. All rights reserved.

//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeamPhoto : NSObject

+(TeamPhoto*)sharedInstance;

-(UIImage*)getImageWithName:(NSString*)name;

@property (strong, nonatomic) NSArray* imageNames;

@end

NS_ASSUME_NONNULL_END
