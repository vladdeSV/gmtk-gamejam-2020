module game.folders.ps.folder_ps_dream;

import game.folders.folder;
import game.folders.boss.folder_boss_vital;

class FolderPsDream : Folder
{
    enum name = "HopesAndDreams";

    this()
    {
        super(this.name);
    }

    override bool isFolderCompleted()
    {
        auto filesInDirectory = this.gameFilesInCurrentDirectory().length;

        return filesInDirectory < 3;
    }

    override void onFolderCompleted()
    {
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

        file = File(this.pathForFileInCurrentFolder("Real Life.jpg"), "wb");
        file.rawWrite(import("dream-1.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("Not a Dream.jpg"), "wb");
        file.rawWrite(import("dream-2.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("Can Happen.jpg"), "wb");
        file.rawWrite(import("dream-3.jpg"));
        file.close();
    }
}
