module game.communication;

import std.stdio : write;
import std.string : wrap;

class Communication
{
    debug bool skipPause = false;

    void sayVirus(string text, int pauseSteps = 3)
    {
        write("( " ~ text ~ " )".wrap());
        this.pause(pauseSteps);
    }

    void sayKaren(string text, int pauseSteps = 3)
    {
        write("K.A.R.E.N.: " ~ text.wrap(80, null, "            "));
        this.pause(pauseSteps);
    }

    void saySystem(string text, int pauseSteps = 3)
    {
        write("System: " ~ text.wrap(80, null, "        "));
        this.pause(pauseSteps);
    }

    void sayNormal(string text, int pauseSteps = 3)
    {
        write(text.wrap(80));
        this.pause(pauseSteps);
    }

    void pause(int steps = 2)
    {
        import core.thread : Thread, msecs;

        if(!this.skipPause)
        {
            Thread.sleep((1000*steps).msecs);
        }
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
