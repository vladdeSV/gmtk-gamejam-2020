module game.folders.boss.folder_boss_restricted;

import game.folders.folder;
import game.folders.word.folder_word_binary;

class FolderBossRestricted : Folder
{
    enum name = "RestrictedAccess";

    this()
    {
        super(this.name);
    }

    override void onCreate()
    {
        this.createFiles();
    }

    override void onFolderCompleted()
    {
        this.parent.parent.parent.corrupt = true;
        this.parent.parent.parent.parent.children[FolderWordBinary.name].visible = true;
    }

    override bool isFolderCompleted()
    {
        import std.file : exists;

        return !exists(this.pathForFileInCurrentFolder("DELETE"));
    }

    override void createFiles()
    {
        import std.stdio : File;

        File(this.pathForFileInCurrentFolder("DELETE"), "w").close();
    }
}
