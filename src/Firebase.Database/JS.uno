using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Firebase.Database;

namespace Firebase.Database.JS
{
    /**
    */
    [UXGlobalModule]
    public sealed class DatabaseModule : NativeEventEmitterModule
    {
        static readonly DatabaseModule _instance;

        public DatabaseModule() : base(false,"data", "dataAdded", "dataChanged", "dataRemoved", "dataMoved", "readByQueryEndingAtValue")
        {
            if(_instance != null) return;
            Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Database");

            DatabaseService.Init();
            var onData = new NativeEvent("onData");
            On("data", onData);

            var onDataAdded = new NativeEvent("onDataAdded");
            On("dataAdded", onDataAdded);

            var onDataChanged = new NativeEvent("onDataChanged");
            On("dataChanged", onDataChanged);

            var onDataRemoved = new NativeEvent("onDataRemoved");
            On("dataRemoved", onDataRemoved);

            var onDataMoved = new NativeEvent("onDataMoved");
            On("dataMoved", onDataMoved);

            var onReadByQueryEndingAtValue = new NativeEvent("onReadByQueryEndingAtValue");
            On("readByQueryEndingAtValue", onReadByQueryEndingAtValue);

            AddMember(onData);
            AddMember(onDataAdded);
            AddMember(onDataChanged);
            AddMember(onDataRemoved);
            AddMember(onDataMoved);
            AddMember(onReadByQueryEndingAtValue);
            AddMember(new NativeFunction("listen", (NativeCallback)Listen));
            AddMember(new NativeFunction("listenOnAdded", (NativeCallback)ListenForChildAdded));
            AddMember(new NativeFunction("listenOnChanged", (NativeCallback)ListenForChildChanged));
            AddMember(new NativeFunction("listenOnRemoved", (NativeCallback)ListenForChildRemoved));
            AddMember(new NativeFunction("listenOnMoved", (NativeCallback)ListenForChildMoved));
            AddMember(new NativeFunction("readByQueryEndingAtValue", (NativeCallback)ReadByQueryEndingAtValue));
            AddMember(new NativeFunction("detachListeners", (NativeCallback)DetachListeners));
            AddMember(new NativePromise<string, string>("read", Read, null));
            AddMember(new NativePromise<string, string>("readByQueryEqualToValue", ReadByQueryEqualToValue, null));
            AddMember(new NativeFunction("push", (NativeCallback)Push));
            AddMember(new NativeFunction("pushWithTimestamp", (NativeCallback)PushWithTimestamp));
            AddMember(new NativeFunction("save", (NativeCallback)Save));
            AddMember(new NativeFunction("delete", (NativeCallback)Delete));
        }

        static Future<string> Read(object[] args)
        {
            var path = args[0].ToString();
            return new Read(path);
        }

        static Future<string> ReadByQueryEqualToValue(object[] args)
        {
            var path = args[0].ToString();
            var key = args[1].ToString();
            var val = args[2];

            if defined(iOS)
            {
                return new ReadByQueryEqualToValue(
                    path, key,
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(val))
                );
            }
            else if defined(Android)
            {
                return new ReadByQueryEqualToValue(
                    path, key,
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(val))
                );
            }
            else
            {
                return new ReadByQueryEqualToValue(path,key,val);
            }
        }

        static void DoSave(string path, object arg)
        {
            if (arg is Fuse.Scripting.Object)
            {
                var p = (Fuse.Scripting.Object)arg;
                var keys = p.Keys;
                string[] objs = new string[keys.Length];
                for (int i=0; i < keys.Length; i++)
                {
                    if (p[keys[i]] == null)
                    {
                        objs[i] = null;
                    }
                    else
                    {
                        objs[i] = p[keys[i]].ToString();
                    }
                }
                DatabaseService.Save(path, keys, objs, keys.Length);
                return;
            }
            else if (arg is Fuse.Scripting.Array)
            {
                var arr = (Fuse.Scripting.Array)arg;
                string[] narr = new string[arr.Length];
                for (int i=0; i < arr.Length; i++)
                {
                    narr[i] = arr[i].ToString();
                }
                DatabaseService.Save(path, narr);
            }
            else if (arg is string)
            {
                DatabaseService.Save(path, arg as string);
                return;
            }
            else if (arg is double || arg is int)
            {
                DatabaseService.Save(path, Marshal.ToDouble(arg));
                return;
            }
            else if (arg == null)
            {
                DatabaseService.SaveNull(path);
                return;
            }
            else
            {
                debug_log("Save: Unimplemented Javascript type");
                debug_log arg;
                debug_log arg.GetType();
                throw new Exception("Save: Unimplemented Javascript type");
            }
        }

        static object Push(Fuse.Scripting.Context context, object[] args)
        {
            var path = args[0].ToString();
            var push_path = DatabaseService.NewChildId(path);
            if defined(iOS)
            {
                DatabaseService.Save(
                    path + "/" + push_path,
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else if defined(Android)
            {
                DatabaseService.Save(
                    path + "/" + push_path,
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else
            {
                DoSave(
                    path + "/" + push_path,
                    args[1]
                );
            }
            return push_path;
        }

        static object PushWithTimestamp(Fuse.Scripting.Context context, object[] args)
        {
            var path = args[0].ToString();
            var push_path = DatabaseService.NewChildId(path);
            if defined(iOS)
            {
                DatabaseService.SaveWithTimestamp(
                    path + "/" + push_path,
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else if defined(Android)
            {
                DatabaseService.SaveWithTimestamp(
                    path + "/" + push_path,
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else
            {
                DoSave(
                    path + "/" + push_path,
                    args[1]
                );
            }
            return push_path;
        }

        static object Save(Fuse.Scripting.Context context, object[] args)
        {
            if defined(iOS)
            {
                DatabaseService.Save(
                    args[0].ToString(),
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else if defined(Android)
            {
                DatabaseService.Save(
                    args[0].ToString(),
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else
            {
                DoSave(
                    args[0].ToString(),
                    args[1]
                );
            }
            return null;
        }

        static object Delete(Fuse.Scripting.Context context, object[] args)
        {
            DatabaseService.SaveNull(args[0].ToString());
            return null;
        }

        void ListenCallback (string path, string msg)
        {
            Emit("data", path, msg);
        }

        void ListenAddedCallback (string path, string msg)
        {
            Emit("dataAdded", path, msg);
        }

        void ListenChangedCallback (string path, string msg)
        {
            Emit("dataChanged", path, msg);
        }

        void ListenRemovedCallback (string path, string msg)
        {
            Emit("dataRemoved", path, msg);
        }

        void ListenMovedCallback (string path, string msg)
        {
            Emit("dataMoved", path, msg);
        }

        void ListenReadByQueryEndingAtValueCallback (string path, string msg)
        {
            Emit("readByQueryEndingAtValue", path, msg);
        }

        object Listen(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "listen";
            var path = args[0].ToString();
            DatabaseService.Listen(path, ListenCallback);
            return null;
        }

        object ListenForChildAdded(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "ListenForChildAdded";
            var path = args[0].ToString();
            int count = Marshal.ToInt(args[1]);
            DatabaseService.ListenForChildAdded(path,count, ListenAddedCallback);
            return null;
        }

        object ListenForChildChanged(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "ListenForChildChanged";
            var path = args[0].ToString();
            DatabaseService.ListenForChildChanged(path, ListenChangedCallback);
            return null;
        }

        object ListenForChildRemoved(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "ListenForChildRemoved";
            var path = args[0].ToString();
            DatabaseService.ListenForChildRemoved(path, ListenRemovedCallback);
            return null;
        }

        object ListenForChildMoved(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "ListenForChildMoved";
            var path = args[0].ToString();
            DatabaseService.ListenForChildMoved(path, ListenMovedCallback);
            return null;
        }

        object ReadByQueryEndingAtValue(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "ReadByQueryEndingAtValue";
            var path = args[0].ToString();
            var keyName = args[1].ToString();
            var lastValue = args[2].ToString();
            int count = Marshal.ToInt(args[3]);
            DatabaseService.ReadByQueryEndingAtValue(path,keyName,lastValue, count, ListenReadByQueryEndingAtValueCallback);
            return null;
        }

        object DetachListeners(Fuse.Scripting.Context context, object[] args)
        {
            debug_log "DetachListeners";
            var path = args[0].ToString();
            DatabaseService.DetachListeners(path);
            return null;
        }
    }
}
