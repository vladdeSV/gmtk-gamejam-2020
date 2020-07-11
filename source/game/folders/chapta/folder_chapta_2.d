module game.folders.chapta.folder_chapta_2;

import game.folders.folder;
import game.misc;
import std.array : array;
import std.algorithm;

class FolderChapta2 : Folder
{
    enum name = "Chapta 2";

    this()
    {
        super(FolderChapta2.name, false);
    }

    override bool isFolderCompleted()
    {
        return true;//filesInFolder(this.getFolderPath()).filter!(a => a == "lorem").array() == ["lorem"];
    }
}
