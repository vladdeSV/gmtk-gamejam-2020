module game.communication;

import std.stdio : write;
import std.string : wrap;

class Communication
{
    void sayVirus(string text)
    {
        write("( " ~ text ~ " )".wrap());
    }

    void sayKaren(string text)
    {
        write("K.A.R.E.N.: " ~ text.wrap(80, null, "            "));
    }

    void saySystem(string text)
    {
        write("System: " ~ text.wrap(80, null, "        "));
    }

    void sayNormal(string text)
    {
        write(text.wrap(80));
    }

    void pause(int steps = 2)
    {
        import core.thread : Thread, msecs;

        //Thread.sleep((2000*steps).msecs);
    }

    static Communication get()
    {
        if (!instantiated_)
        {
            synchronized (Communication.classinfo)
            {
                if (!instance_)
                {
                    instance_ = new Communication();
                }

                instantiated_ = true;
            }
        }

        return instance_;
    }

    private this()
    {
    }

    private static bool instantiated_;
    private __gshared Communication instance_;
}
