module game.folders.ps.folder_ps_extreme;

import game.folders.folder;
import game.folders.ps.folder_ps_dream;

class FolderPsExtreme : Folder
{
    enum name = "EXTREME";

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
        this.children[FolderPsDream.name].visible = true;
    }

    override void onCreate()
    {
        this.createFiles();
        
        auto c = new FolderPsDream();
        c.visible = false;
        this.addChild(c);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("XTRM.jpg"), "wb");
        file.rawWrite(import("extreme-1.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("EXTREMEMENT.jpg"), "wb");
        file.rawWrite(import("extreme-2.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("XTREME 2.jpg"), "wb");
        file.rawWrite(import("extreme-3.jpg"));
        file.close();
    }
}
