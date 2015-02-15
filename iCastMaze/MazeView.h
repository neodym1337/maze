//


#import <UIKit/UIKit.h>

@class MazeView;
@class MazePlayer;

@protocol MazeViewDelegate <NSObject>

- (void)mazeView:(MazeView *)view selectedMove:(MazeMove)movment;
- (MazePlayer *)mazeViewPlayer:(MazeView *)view;

@end

@interface MazeView : UIView

@property(nonatomic, weak)id<MazeViewDelegate>  delegate;

- (void)reload;

@end
