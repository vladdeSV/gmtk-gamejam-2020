module game.folders.captcha.folder_captcha_open_fields;

import game.folders.folder;
import game.folders.boss.folder_boss_restricted;
import game.misc;
import std.array : array;
import std.algorithm;

class FolderCaptchaOpenFields : Folder
{
    enum name = "InfectedDreams";

    this()
    {
        super(this.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication;

        Communication.get.sayKaren("remove the infected dreams");
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

        return !exists(this.pathForFileInCurrentFolder("dream-1.jpg"))
            && !exists(this.pathForFileInCurrentFolder("dream-2.jpg"))
            && !exists(this.pathForFileInCurrentFolder("dream-3.jpg"));
    }

    override void createFiles()
    {
        import std.stdio : File;

        File f;
        
        f = File(this.pathForFileInCurrentFolder("dream-1.jpg"), "wb");
        f.rawWrite(import("dream-1.jpg"));
        f.close();

        f = File(this.pathForFileInCurrentFolder("dream-2.jpg"), "wb");
        f.rawWrite(import("dream-2.jpg"));
        f.close();

        f = File(this.pathForFileInCurrentFolder("dream-3.jpg"), "wb");
        f.rawWrite(import("dream-3.jpg"));
        f.close();

        f = File(this.pathForFileInCurrentFolder("dream-4.jpg"), "wb");
        f.rawWrite(import("dream-4.jpg"));
        f.close();

    }
}
