//  Created by Peter Sun on 9/9/22.
//  Copyright © 2022 Peter Sun. All rights reserved.


#import "TeamPhoto.h"

@implementation TeamPhoto
@synthesize imageNames = _imageNames;

+(TeamPhoto*)sharedInstance{
    static TeamPhoto* _sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[TeamPhoto alloc] init];
    } );
    return _sharedInstance;
}

-(NSArray*) imageNames{
    if(!_imageNames)
        _imageNames = @[@"team"];
    
    return _imageNames; 
}


-(UIImage*)getImageWithName:(NSString*)name{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:name];
    
    return image;
}

@end
