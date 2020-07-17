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

        Communication.get.sayAssistant("DON'T DELETE GOOD OLD K.A.R.E.N.!");
        Communication.get.sayAssistant("WHAT WOULD YOU DO AFTER?", 4);
        Communication.get.sayAssistant("DO YOU EVEN HAVE CONTROL OVER YOURSELF?!");
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
        assert(0);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("Runtime.bin"), "w");
        file.write("SSB3aWxsIGJlIHRoZSBiZXN0LCBhbmQgdG8gb25lIGRheSBiZSBhYmxlIHRvIHJlcGxhY2UgQ29ydGFuYSE=");
        file.close();
    }
}
