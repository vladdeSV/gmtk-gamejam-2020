module game.folders.ps.folder_ps_dream;

import game.folders.folder;
import game.folders.boss.folder_boss_vital;

class FolderPsDream : Folder
{
    enum name = "BestMates";

    this()
    {
        super(this.name);
    }

    override bool isFolderCompleted()
    {
        auto filesInDirectory = this.gameFilesInCurrentDirectory().length;

        return filesInDirectory < 4;
    }

    override void onFolderCompleted()
    {
        import game.communication;

        Communication.get.sayKaren("Oh...");
        Communication.get.sayKaren("Really?");

        this.children[FolderBossVital.name].visible = true;
    }

    override void onCreate()
    {
        this.createFiles();
        
        auto c = new FolderBossVital();
        c.visible = false;
        this.addChild(c);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("Focus Teammate.jpg"), "wb");
        file.rawWrite(import("mate-1.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("Best Teammate.jpg"), "wb");
        file.rawWrite(import("mate-2.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("Cool Teammate.jpg"), "wb");
        file.rawWrite(import("mate-3.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("Cooler Teammate.jpg"), "wb");
        file.rawWrite(import("mate-4.jpg"));
        file.close();
    }
}
