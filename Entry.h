@interface Entry : NSObject
@property(nonatomic) NSInteger index;
@property(strong, nonatomic) NSNumber *data;
- (id)initWithIndex:(NSInteger)index data:(NSNumber *)data;
@end
