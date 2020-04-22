//
//  TIFRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2019/4/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TIFRLM : RLMObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *images;
@property (nonatomic, copy) NSString *files;
@property (nonatomic, copy) NSString *ext;
@end

NS_ASSUME_NONNULL_END
