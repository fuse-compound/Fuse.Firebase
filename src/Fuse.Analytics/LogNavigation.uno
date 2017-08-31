using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Navigation;

namespace Fuse.Analytics
{
	public class LogNavigation: Behavior
	{
		public void OnActivePageChanged(object r, Fuse.Visual vis) {
			Fuse.Analytics.Provider.LogPage(vis.Name);
		}

        public void OnHistoryChanged(object r) {
        	string page = "";
        	string path = "";
        	if (r is Router) {
        		var router = r as Router;
        		var route = router.GetCurrentRoute();
        		var len = route.Length;
        		for (int i = 0; i < len; i++)
        		{
        			path = path + "/" + route.Path;
        			page = route.Path;
        			// debug_log route.Path;
        			// debug_log route.Parameter;
        			// debug_log route.SubRoute;
        			route = route.SubRoute;
        		}
        	}


        	Fuse.Analytics.Provider.LogPage(page, path);
        }

        Fuse.Navigation.IBaseNavigation _navigation = null;
        public Fuse.Navigation.IBaseNavigation Navigation {
            get { return _navigation; }
            set {
                // Remove old handler:
                if (_navigation != null) {
                    if (_navigation is Fuse.Navigation.INavigation) {
                        var _in = _navigation as Fuse.Navigation.INavigation;
                        _in.ActivePageChanged -= OnActivePageChanged;
                    }
                    else {
                        _navigation.HistoryChanged -= OnHistoryChanged;
                    }
                }

                // Set value
                _navigation = value;

                // Add new handler:
                if (_navigation != null) {
                    if (_navigation is Fuse.Navigation.INavigation) {
                        var _in = _navigation as Fuse.Navigation.INavigation;
                        _in.ActivePageChanged += OnActivePageChanged;
                    }
                    else {
                        _navigation.HistoryChanged += OnHistoryChanged;
                    }
                }
            }
        }


	}
}
