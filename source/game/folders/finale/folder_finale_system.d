module game.folders.finale.folder_finale_system;

import game.folders.folder;
import game.folders.finale.folder_finale_core;

class FolderFinaleSystem : Folder
{
    enum name = "System";

    this()
    {
        super(this.name);
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
