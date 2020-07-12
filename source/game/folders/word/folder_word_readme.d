module game.folders.word.folder_word_readme;

import game.folders.folder;

class FolderWordReadme : Folder
{
    enum name = "AllYourReadAreBelongToMe";

    this()
    {
        super(this.name);
    }

    override bool isFolderCompleted()
    {
        //auto filesInDirectory = this.gameFilesInCurrentDirectory().length;

        //return filesInDirectory < 3;

        return true;
    }

    override void onFolderCompleted()
    {
        //this.children[FolderPsExtreme.name].visible = true;
    }

    override void onCreate()
    {
        //auto c = new FolderPsExtreme();
        //c.visible = false;
        //this.addChild(c);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("README.txt"), "w");
        file.rawWrite("");
        file.close();
    }
}
