module game.folders.chapta.folder_chapta_1;

import game.folders.chapta.folder_chapta_2;
import game.folders.folder;
import game.misc;
import game.player : Player;
import std.algorithm;
import std.array : array;
import std.stdio : File;

class FolderChapta1 : Folder
{
    enum name = "Chapta 1";

    this()
    {
        super(FolderChapta1.name, true);
    }

    override void onCreate()
    {
        this.createFiles();

        auto c2 = new FolderChapta2();
        this.addChild(c2);
    }

    override bool isFolderCompleted()
    {
        auto folderFiles = this.gameFilesInCurrentDirectory();
        return folderFiles == ["file1.jpg"];
    }

    override void onFolderCompleted()
    {
        this.children[FolderChapta2.name].visible = true;
    }

    override void createFiles()
    {
        enum data = ["mug.jpg", "HUMAN_NAMED_BOB.jpg"];

        static foreach (n, filename; data)
        {
            import std.conv : text;
            import std.array : split, array;
            import std.algorithm;

            mixin(text("File f", n, " = File(text(this.getFolderPath(), \"\\\\file\", n + 1, \".jpg\"), \"wb\");"));
            mixin(text("f", n, ".rawWrite(import(filename));"));
            mixin(text("f", n, ".close();"));
        }

        /+
        File(this.getFolderPath() ~ "\\file1.jpg", "w+");
        File(this.getFolderPath() ~ "\\file2.jpg", "w+");
        File(this.getFolderPath() ~ "\\file3.jpg", "w+");
        File(this.getFolderPath() ~ "\\file4.jpg", "w+");
        File(this.getFolderPath() ~ "\\file5.jpg", "w+");
        File(this.getFolderPath() ~ "\\file6.jpg", "w+");
        File(this.getFolderPath() ~ "\\file7.jpg", "w+");
        File(this.getFolderPath() ~ "\\file8.jpg", "w+");
        File(this.getFolderPath() ~ "\\file9.jpg", "w+");
        +/
    }
}
