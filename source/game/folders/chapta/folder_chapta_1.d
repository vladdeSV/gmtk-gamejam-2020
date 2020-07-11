module game.folders.chapta.folder_chapta_1;

import game.folders.folder;
import game.folders.chapta.folder_chapta_2;
import game.misc;
import std.array : array;
import std.algorithm;
import std.stdio : File;

class FolderChapta1 : Folder
{
    this()
    {
        super("Chapta", true);
    }

    override void onCreate()
    {
        this.createFiles();

        auto c2 = new FolderChapta2();
        this.addChild(c2);
    }

    override bool isFolderCompleted()
    {
        auto a = filesInFolder(this.getFolderPath()).filter!(a => a != "virus").map!(a => a.name.filenameFromFilePath).array();
        
        return a == ["file1.jpg"];
    }

    override void onFolderCompleted()
    {
        this.children[FolderChapta2.name].visible = true;
    }

    override void createFiles()
    {
        File(this.getFolderPath() ~ "\\file1.jpg", "w+");
        File(this.getFolderPath() ~ "\\file2.jpg", "w+");
        File(this.getFolderPath() ~ "\\file3.jpg", "w+");
        File(this.getFolderPath() ~ "\\file4.jpg", "w+");
        File(this.getFolderPath() ~ "\\file5.jpg", "w+");
        File(this.getFolderPath() ~ "\\file6.jpg", "w+");
        File(this.getFolderPath() ~ "\\file7.jpg", "w+");
        File(this.getFolderPath() ~ "\\file8.jpg", "w+");
        File(this.getFolderPath() ~ "\\file9.jpg", "w+");
    }
}
