module game.folders.finale.folder_finale_core;

import game.folders.folder;

class FolderFinaleCore : Folder
{
    enum name = "Core";

    this()
    {
        super(this.name);
    }
    
    override void onFirstTimeEnterByPlayer()
    {
        import game.communication : Communication;

        Communication.get.sayKaren("no... how did you get here. please do not touch me.");
    }

    override void onCreate()
    {
        this.createFiles();
    }

    override bool isFolderCompleted()
    {
        import std.algorithm: canFind, map;
        import std.array: array;
        import std.uni : toLower;

        return this.gameFilesInCurrentDirectory().length == 0;
    }

    override void onFolderCompleted()
    {
        //this.children[FolderFinaleCore.name].visible = true;
        assert(0);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("Runtime.bin"), "w");
        file.write("01001100 01001111 01010110 01000101");
        file.close();

        file = File(this.pathForFileInCurrentFolder("Memory.mem"), "w");
        file.write("SSB3aWxsIGJlIHRoZSBiZXN0LCBhbmQgdG8gb25lIGRheSBiZSBhYmxlIHRvIHJlcGxhY2UgQ29ydGFuYSE=");
        file.close();
    }
}
