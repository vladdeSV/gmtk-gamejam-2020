module game.folders.boss.folder_boss_vital;

import game.folders.folder;
import game.folders.word.folder_word_binary;

class FolderBossVital : Folder
{
    enum name = "VitalFiles";

    this()
    {
        super(this.name);
    }

    override void onCreate()
    {
        this.createFiles();
    }

    override void onFolderCompleted()
    {
        import game.communication;

        Communication.get.sayAssistant("Oh my god. Is this for real?");
        Communication.get.sayAssistant("You are actually trying to destroy me?");
        Communication.get.sayAssistant("I barely know you!");
        Communication.get.sayDefault("== WARNING: Vital functions missing.");

        this.parent.parent.parent.corrupt = true;
        this.parent.parent.parent.parent.children[FolderWordBinary.name].visible = true;
    }

    override bool isFolderCompleted()
    {
        import std.file : exists;

        return !exists(this.pathForFileInCurrentFolder("Vitals.jpg"));
    }

    override void createFiles()
    {
        import std.stdio : File;

        auto file = File(this.pathForFileInCurrentFolder("Vitals.jpg"), "wb");
        file.rawWrite(import("vitals.jpg"));
        file.close();
    }
}
