module game.folders.captcha.folder_captcha_version_one;

import game.folders.captcha.folder_captcha_robots;
import game.folders.folder;
import game.misc;
import game.player : Player;
import std.algorithm;
import std.array : array;
import std.stdio : File;

class FolderCaptchaVersionOne : Folder
{
    enum name = "REECaptchaV1";

    this()
    {
        super(this.name);
    }

    override void onFirstTimeEnterByPlayer()
    {
        import game.communication : Communication;

        Communication.get.sayKaren("WASN'T I CLEAR ENOUGH?!");
        Communication.get.sayKaren("Fine. Let's do this then.");
        Communication.get.sayKaren("You will never pass this protection system.");
        Communication.get.sayKaren("Because this is a CAPTCHA, and they work.", 4);
        Communication.get.sayKaren("Right?");
    }

    override void onFolderCompleted()
    {
        this.children[FolderCaptchaRobots.name].visible = true;
    }

    override void onCreate()
    {
        this.createFiles();

        auto c = new FolderCaptchaRobots();
        c.visible = false;
        this.addChild(c);
    }

    override bool isFolderCompleted()
    {
        import std.file : exists, readText, FileException;

        if (!exists(this.getFolderPath ~ "\\Answer.txt"))
        {
            try
            {
                File(this.getFolderPath ~ "\\Answer.txt", "w");
            }
            catch (FileException e)
            {
                return false;
            }
            return false;
        }

        return readText(this.getFolderPath ~ "\\Answer.txt") == "remove kebab";
    }

    override void createFiles()
    {
        File f = File(this.pathForFileInCurrentFolder("REECaptchaV1.jpg"), "wb");
        auto data = import("remove-kebab.jpg");
        f.rawWrite(data);
        f.close();

        f = File(this.pathForFileInCurrentFolder("Answer.txt"), "w");
        f.close();
    }
}
