module game.folders.captcha.folder_captcha_robots;

import game.folders.captcha.folder_captcha_open_fields;
import game.folders.folder;
import game.misc;
import std.algorithm;
import std.array : array;

class FolderCaptchaRobots : Folder
{
    enum name = "SelectRobots";

    this()
    {
        super(FolderCaptchaRobots.name);
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
        enum files = [
            "mug.jpg", //ok
            "human-named-bob.jpg",
            "human-mother-with-child.jpg",
            "karen-and-human.jpg",
            "robot-not-human-i-swear.jpg", // ok
            "more-human-than-you.jpg",
            "bob.jpg", // ok
        ];

        import std.stdio : File;
        import std.conv : text;
        import std.array : split, array;
        import std.conv : text;
        import std.algorithm;

        //File f;
        //string data;
        static foreach (n, filename; files)
        {
            mixin(text("File f", n, " = File(text(this.getFolderPath(), \"\\\\file\", n + 1, \".jpg\"), \"wb\");"));
            mixin(text("auto data", n, " = import(filename);"));
            mixin(text("f", n, ".rawWrite(data",n,");"));
            mixin(text("f", n, ".close();"));
        }
    }
}
