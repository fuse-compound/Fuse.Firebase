using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;
using Uno.Threading;

namespace Firebase.Analytics
{
    public class Provider: Fuse.Analytics.IProvider {
        public Provider() {
            debug_log "Firebase.Analytics.Provider constructor";
            AnalyticsService.Init();
        }

        public void LogEvent(string name, string[] keys, string[] vals, int len, bool timed) {
            debug_log "Firebase.LogEvent[" + name + "] ";
            Firebase.Analytics.AnalyticsService.LogEvent(name, keys, vals, len);
        }

        public void EndTimedEvent(string name, string[] keys, string[] vals, int len) {
            debug_log "Firebase.EndTimedEvent not implemented!";
        }

        public void LogPage(string page, string path) {
        	var k = new List<string>();
        	var v = new List<string>();
        	if (page != null) {
        		k.Add("page");
        		v.Add(page);
        	}
        	if (path != null) {
        		k.Add("path");
        		v.Add(path);
        	}
        	LogEvent("view_item", k.ToArray(), v.ToArray(), k.Count, true);
        }


    }
}
