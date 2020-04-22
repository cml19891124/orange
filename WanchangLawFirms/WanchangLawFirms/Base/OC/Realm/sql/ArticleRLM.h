//
//  ArticleRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2019/1/24.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 文章浏览位置表
@interface ArticleRLM : RLMObject
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *article_offset_y;
@end

NS_ASSUME_NONNULL_END
