module game.folders.captcha.folder_captcha_robots;

import game.folders.captcha.folder_captcha_open_fields;
import game.folders.folder;
import game.misc;
import std.algorithm;
import std.array : array;

class FolderCaptchaRobots : Folder
{
    enum name = "REEChaptaV2";

    this()
    {
        super(FolderCaptchaRobots.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication : Communication;

        Communication.get.sayKaren("remove all images containing robots to continue");
        Communication.get.pause(1);
        Communication.get.sayVirus("to reset progress, delete this entire folder");
    }

    override void onCreate()
    {
        this.createFiles();

        auto c = new FolderCaptchaOpenFields();
        c.visible = false;
        this.addChild(c);
    }

    override bool isFolderCompleted()
    {
        return this.gameFilesInCurrentDirectory() == ["file1.jpg", "file5.jpg", "file7.jpg"];
    }

    override void onFolderCompleted()
    {
        this.children[FolderCaptchaOpenFields.name].visible = true;
    }

    override void createFiles()
    {
        import std.stdio : File;
        import std.conv : text;
        import std.array : split, array;
        import std.conv : text;
        import std.algorithm;

        enum files = [
            "mug.jpg", //ok
            "human-named-bob.jpg",
            "human-mother-with-child.jpg",
            "karen-and-human.jpg",
            "robot-not-human-i-swear.jpg", // ok
            "more-human-than-you.jpg",
            "bob.jpg", // ok
        ];

        File f;
        string data;
        static foreach (n, filename; files)
        {
            f = File(this.pathForFileInCurrentFolder(text("\\file", n + 1, ".jpg")), "wb");
            data = import(filename);
            f.rawWrite(data);
            f.close();
        }
    }
}
