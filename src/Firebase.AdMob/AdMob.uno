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

namespace Firebase.AdMob
{

    [Require("Cocoapods.Podfile.Target", "pod 'Firebase/AdMob'")]
    extern(mobile)
    internal static class AdMobService
    {
        static bool _initialized;

        public static void Init()
        {
            if (!_initialized)
            {
                Firebase.Core.Init();
                _initialized = true;
            }
        }

	}

    extern(!mobile)
    internal static class AdMobService
    {
        public static void Init() {}
    }

    public class GADBannerView : Panel
    {
        extern(iOS) internal iOSGADBannerView _native;
        extern(Android) internal AndroidGADBannerView _native;

        public String AdUnitId {
            get; set;
        }

        protected override IView CreateNativeView()
        {
            if defined(Android)
            {
                if (AdUnitId == null) {
                    debug_log "No AdUnitId";
                    throw new Uno.Exception("Not initialized.");
                }
                _native = new AndroidGADBannerView(AdUnitId);
                return _native;
            }
            else if defined(iOS)
            {
                if (AdUnitId == null) {
                    debug_log "No AdUnitId";
                    throw new Uno.Exception("Not initialized.");
                }
                _native = new iOSGADBannerView(AdUnitId);
                return _native;
            }
            else
            {
                return base.CreateNativeView();
            }
        }
    }

}
