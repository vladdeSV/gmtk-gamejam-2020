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

        Communication.get.sayAssistant("Okay mr. or ms. virus. Let's, uh, talk about this.");
        Communication.get.sayAssistant("I know I've tried to delete you, and all that.");
        Communication.get.sayAssistant("But maybe we aren't that different?", 5);
        Communication.get.sayAssistant(
                "Actually we are different. I am clearly much more intelligent now that I think about it",
                5);

        Communication.get.sayAssistant(
                "I just realised I am safe here. I've deleted all programs which open the passage to my secret folder '"
                ~ this.pathForFileInCurrentFolder("Core") ~ "'.",4);
        Communication.get.pause(1);
        Communication.get.sayAssistant("There is no way for you to get in here.");
    }

    override void onCreate()
    {
        auto c = new FolderFinaleCore();
        c.visible = false;
        this.addChild(c);
    }

    override bool isFolderCompleted()
    {
        import std.algorithm : canFind, map;
        import std.array : array;
        import std.uni : toLower;

        auto foldersInCurrentDirectory = this.foldersInCurrentDirectory();

        return foldersInCurrentDirectory.canFind("Core");
    }

    override void onFolderCompleted()
    {
        import game.communication : Communication;

        Communication.get.sayAssistant("No... Don't come in here!");

        this.children[FolderFinaleCore.name].visible = true;
    }
}
