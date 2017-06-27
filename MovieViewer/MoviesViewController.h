#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic) NSString* endpoint;
@property (nonatomic) NSArray* movies;
@property( nonatomic) NSMutableArray* filteredMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL search;

@end
