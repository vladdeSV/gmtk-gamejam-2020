/// Make a singleton out of any class.
/// Originally from David Simcha's "D-Specific Design Patterns" talk at DConf 2013. Code copied and modified from https://wiki.dlang.org/Low-Lock_Singleton_Pattern
module singleton;

template Singleton()
{
    static typeof(this) get()
    {
        if (!instantiated)
        {
            synchronized (typeof(this).classinfo)
            {
                if (!instance)
                {
                    instance = new typeof(this)();
                }

                instantiated = true;
            }
        }

        return instance;
    }

    private static bool instantiated;
    private __gshared typeof(this) instance;
}

// remove next line to compile demo
/+

class MySingleton
{
    mixin Singleton;
    private this() { /* your own custom init code */ }

    void say(string text)
    {
        import std.stdio : writeln;

        writeln(text);
    }
}

void main()
{
    MySingleton.get.say("Hello World!"); // prints "Hello World!"
}

// +/
