#import <UIKit/UIKit.h>

typedef struct
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
}RGBA;

@interface UIColor (RGBA)

/**
 *  获取UIColor对象的RGBA值
 *
 *  @param color UIColor
 *
 *  @return RGBA
 */
RGBA RGBAFromUIColor(UIColor *color);

@end
