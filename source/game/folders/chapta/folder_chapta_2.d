module game.folders.chapta.folder_chapta_2;

import game.folders.chapta.folder_chapta_3;
import game.folders.folder;
import game.misc;
import std.algorithm;
import std.array : array;

class FolderChapta2 : Folder
{
    enum name = "Chapta 2";

    this()
    {
        super(FolderChapta2.name, false);
    }

    override void onCreate()
    {
        this.createFiles();

        auto c3 = new FolderChapta3();
        this.addChild(c3);
    }

    override bool isFolderCompleted()
    {
        return true; //filesInFolder(this.getFolderPath()).filter!(a => a == "lorem").array() == ["lorem"];
    }

    override void onFolderCompleted()
    {
        this.children[FolderChapta3.name].visible = true;
    }
}
