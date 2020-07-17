module game.communication;

import std.stdio : write;
import std.string : wrap;
import singleton : Singleton;
import core.time;

enum ticksPerSecond = 30;

private enum Caller
{
    default_,
    player,
    assistant,
    system,
}

private struct Message
{
    Caller caller;
    string text;
    int durationInSeconds;
}

class Communication
{
    private this()
    {
    }

    private bool skipPause = false;

    mixin Singleton;

    private Message[] messages;
    private void queue(Message message)
    {
        if (messages.length == 0)
        {
            lastTime = MonoTime.currTime() - dur!"seconds"(message.durationInSeconds);
        }

        messages ~= message;
    }

    private MonoTime lastTime;

    void run()
    {
        import std.stdio : writeln;
        import std.conv : text;

        if (this.messages.length == 0)
        {
            return;
        }

        auto currentTime = MonoTime().currTime();

        if (this.skipPause || ((currentTime - this.lastTime)
                .total!"seconds" > messages[0].durationInSeconds))
        {
            auto message = popFront(this.messages);

            // fixme bad hack to get this working;
            if (message.text == "skip true" || message.text == "skip false")
            {
                if (message.text == "skip true")
                {
                    writeln("skipping true");
                    this.skipPause = true;
                }
                else if (message.text == "skip false")
                {
                    writeln("skipping false");
                    this.skipPause = false;
                }

                return;
            }

            if (!this.skipPause)
            {
                lastTime = lastTime + dur!"seconds"(message.durationInSeconds);
            }
            
            printMessage(message);
        }
    }

    void setSkipPause(bool a)
    {
        this.queue(Message(Caller.default_, "skip " ~ (a ? "true" : "false"), 0));
    }

    private T popFront(T)(ref T[] ts)
    in
    {
        assert(ts.length);
    }
    body
    {
        auto first = ts[0];
        ts = ts[1 .. $];
        return first;
    }

    private void printMessage(Message message)
    {
        if (message.text == "")
        {
            return;
        }

        import std.stdio : writeln;
        import std.conv : to;

        auto text = this.formatTextForCaller(message.caller, message.text);

        writeln(to!string(message.caller) ~ ": " ~ text);
    }

    private string formatTextForCaller(Caller caller, string text)
    {
        return text; // fixme
    }

    void sayPlayer(string text, int durationInSeconds = 3)
    {
        //write("( " ~ text ~ " )".wrap());
        //this.pause(durationInSeconds);

        this.queue(Message(Caller.player, text, durationInSeconds));
    }

    void sayAssistant(string text, int durationInSeconds = 3)
    {
        //write("K.A.R.E.N.: " ~ text.wrap(80, null, "            "));
        //this.pause(durationInSeconds);

        this.queue(Message(Caller.assistant, text, durationInSeconds));
    }

    void saySystem(string text, int durationInSeconds = 3)
    {
        //write("System: " ~ text.wrap(80, null, "        "));
        //this.pause(durationInSeconds);

        this.queue(Message(Caller.system, text, durationInSeconds));
    }

    void sayDefault(string text, int durationInSeconds = 3)
    {
        //write(text.wrap());
        //this.pause(durationInSeconds);

        this.queue(Message(Caller.default_, text, durationInSeconds));
    }

    deprecated("Use message pauses instead") void pause(int durationInSeconds = 2)
    {
        this.queue(Message(Caller.default_, "", durationInSeconds));
        /+import core.thread : Thread, msecs;

        if (!this.skipPause)
        {
            Thread.sleep((1000 * durationInSeconds).msecs);
        }
        +/
    }
}
