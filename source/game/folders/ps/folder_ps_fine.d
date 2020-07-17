module game.folders.ps.folder_ps_fine;

import game.folders.folder;
import game.folders.ps.folder_ps_extreme;

class FolderPsFine : Folder
{
    enum name = "AllPicturesAreFine";

    this()
    {
        super(this.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication;

        Communication.get.sayAssistant("I made this protection myself, because I am pretty smart.");
        Communication.get.sayAssistant("It requires intelligence to bypass.", 4);
        Communication.get.sayAssistant("You would have to delete the most ridiculous image. Good luck ;)");
    }

    override bool isFolderCompleted()
    {
        auto filesInDirectory = this.gameFilesInCurrentDirectory().length;

        return filesInDirectory < 3;
    }

    override void onFolderCompleted()
    {
        this.children[FolderPsExtreme.name].visible = true;
    }

    override void onCreate()
    {
        this.createFiles();
        
        auto c = new FolderPsExtreme();
        c.visible = false;
        this.addChild(c);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("THIS IS FINE.jpg"), "wb");
        file.rawWrite(import("this-is-fine-1.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("THIS IS ALSO FINE.jpg"), "wb");
        file.rawWrite(import("this-is-fine-2.jpg"));
        file.close();

        file = File(this.pathForFileInCurrentFolder("IS THIS FINE YES.jpg"), "wb");
        file.rawWrite(import("this-is-fine-3.jpg"));
        file.close();
    }
}
