module game.player;

import game.folders.folder;
import game.misc;
import std.file : exists;
import std.stdio : File, rename;
import std.string : toStringz;
import std.experimental.logger : sharedLog;
import game.communication : Communication;

class Player
{
    enum name = "Virus.exe";
    enum data = "22asd";

    Folder currentlyInFolder;

    void info()
    {
        sharedLog.log("current folder is '", currentlyInFolder.getFolderPath,"'");
        sharedLog.log("folder is inited: ", currentlyInFolder.inited);
        sharedLog.log("folder is visible: ", currentlyInFolder.visible);
        sharedLog.log("folder is complted: ", currentlyInFolder.isFolderCompleted());

        sharedLog.log("folder has children: ", currentlyInFolder.children);
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
            //Communication.get.sayPlayer("Scanning new directory '" ~ this.currentlyInFolder.getFolderPath ~ "\\'");
            folder.onCreate();
            folder.inited = true;
        }

        import game.communication : Communication;
        import std.conv : text;

        if(!folder.visitedByPlayer)
        {
            folder.onFirstTimeEnterByPlayer();
            folder.visitedByPlayer = true;
        }
    }
}
