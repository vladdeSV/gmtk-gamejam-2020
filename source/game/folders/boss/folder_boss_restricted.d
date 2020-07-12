module game.folders.boss.folder_boss_restricted;

import game.folders.folder;
import game.folders.ps.folder_ps_fine;

class FolderBossRestricted : Folder
{
    enum name = "RestrictedAccess";

    this()
    {
        super(this.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication;

        Communication.get.sayKaren("No! You should not be here!");
        Communication.get.sayKaren("System, stop the virus from deleting the important file!");
        Communication.get.saySystem("System is offline.");
    }

    override void onCreate()
    {
        this.createFiles();
    }

    override void onFolderCompleted()
    {
        this.parent.parent.parent.corrupt = true;
        this.parent.parent.parent.parent.children[FolderPsFine.name].visible = true;

        import game.communication;

        Communication.get.sayKaren("H*ck.");
        Communication.get.sayKaren("I can fix this.");
        Communication.get.sayKaren("It wasn't really that important.", 4);
        Communication.get.sayKaren("The User will probably not notice.");
        Communication.get.sayNormal("== WARNING: Audio drivers damaged.");

        import game.audio;

        // todo play error buzz sound
        Audio.get.playTrack(SongTrack.first);
    }

    override bool isFolderCompleted()
    {
        import std.file : exists;

        return !exists(this.pathForFileInCurrentFolder("System Audio.bin"));
    }

    override void createFiles()
    {
        import std.stdio : File;

        File(this.pathForFileInCurrentFolder("System Audio.bin"), "w").close();
    }
}
