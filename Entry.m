#import "Entry.h"

@implementation Entry
- (id)initWithIndex:(NSInteger)index data:(NSNumber *)data {
    self.index = index;
    self.data = data;
    return self;
}
@end
