module game.player;

import game.folders.folder;
import game.misc;
import std.file : exists;
import std.stdio : File, rename;
import std.string : toStringz;

class Player
{
    enum name = "Virus.exe";
    enum data = "22asd";

    Folder currentlyInFolder;

    void info()
    {
        import std.stdio : writeln;
        writeln("current folder is '", currentlyInFolder.getFolderPath,"'");
        writeln("folder is inited: ", currentlyInFolder.inited);
        writeln("folder is visible: ", currentlyInFolder.visible);
        writeln("folder is complted: ", currentlyInFolder.isFolderCompleted());

        writeln("folder has children: ", currentlyInFolder.children);
    }

    this(Folder folder)
    {
        this.currentlyInFolder = folder;

        auto file = File(folder.getFolderPath ~ "\\" ~ Player.name, "w+");
        file.write(Player.data);
        file.close();

        this.moveToFolder(folder);
    }

    // todo: move to own handler
    void moveToFolder(Folder folder)
    {
        import std.stdio;

        assert(this.currentlyInFolder !is null);

        auto from = this.currentlyInFolder.getFolderPath ~ "\\" ~ Player.name;
        auto to = folder.getFolderPath ~ "\\" ~ Player.name;
        if (this.currentlyInFolder !is folder)
        {
            if (exists(from) && exists(to)) 
            {
                deleteFile(to);
            }

            import core.thread : Thread, msecs;
            Thread.sleep(100.msecs);

            rename(from.toStringz(), to.toStringz());
        }
        this.currentlyInFolder = folder;

        if (!folder.inited)
        {
            folder.onCreate();
            folder.inited = true;
        }
    }
}
