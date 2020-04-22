//
//  LawyerOneRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2019/3/3.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LawyerOneRLM : RLMObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *order_star_all;
@property (nonatomic, copy) NSString *order_star_num;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *subscribe_count;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *work_status;
@property (nonatomic, copy) NSString *work_year;
@property (nonatomic, copy) NSString *ext;
@end

NS_ASSUME_NONNULL_END
