module game.folders.captcha.folder_captcha_open_fields;

import game.folders.folder;
import game.folders.boss.folder_boss_restricted;
import game.misc;
import std.array : array;
import std.algorithm;

class FolderCaptchaOpenFields : Folder
{
    enum name = "OpenFields";

    this()
    {
        super(this.name);
    }

    override void onCreate()
    {
        this.createFiles();

        auto c = new FolderBossRestricted();
        c.visible = false;
        this.addChild(c);
    }

    override void onFolderCompleted()
    {
        this.children[FolderBossRestricted.name].visible = true;
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
