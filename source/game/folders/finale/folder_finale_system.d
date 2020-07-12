module game.folders.finale.folder_finale_system;

import game.folders.folder;
import game.folders.finale.folder_finale_core;

class FolderFinaleSystem : Folder
{
    enum name = "KAREN";

    this()
    {
        super(this.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication : Communication;

        Communication.get.sayKaren("you cannot go further. i have remove all programs which lead to the 'Core' folder. in here i am safe.");
        Communication.get.pause(1);
    }

    override void onCreate()
    {
        auto c = new FolderFinaleCore();
        c.visible = false;
        this.addChild(c);
    }

    override bool isFolderCompleted()
    {
        import std.algorithm: canFind, map;
        import std.array: array;
        import std.uni : toLower;

        auto foldersInCurrentDirectory = this.foldersInCurrentDirectory();

        return foldersInCurrentDirectory.canFind("Core");
    }

    override void onFolderCompleted()
    {
        this.children[FolderFinaleCore.name].visible = true;
    }
}
