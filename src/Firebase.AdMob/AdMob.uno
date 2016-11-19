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
        protected override IView CreateNativeView()
        {
            if defined(Android)
            {
                return new AndroidGADBannerView();
            }
            else if defined(iOS)
            {
                return new iOSGADBannerView();
            }
            else
            {
                return base.CreateNativeView();
            }
        }
    }

}
