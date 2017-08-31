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

namespace Fuse.Analytics
{
    public class Provider : Behavior {
        public Provider() {
            debug_log "Fuse.Analytics.Provider constructor";
        }

        static IProvider _instance;
        [UXContent]
        public IProvider Instance {
            get { return _instance; } 
            set { _instance = value; }
        }

        public static void LogPage(string page)
        {
            _instance.LogPage(page, null);
        }
        public static void LogPage(string page, string path)
        {
            _instance.LogPage(page, path);
        }

        public static void LogEvent(string name, string[] keys, string[] vals, int len, bool timed)
        {
            _instance.LogEvent(name,keys,vals,len,timed);
        }

        public static void EndTimedEvent(string name, string[] keys, string[] vals, int len)
        {
            _instance.EndTimedEvent(name,keys,vals,len);
        }

    }
}
