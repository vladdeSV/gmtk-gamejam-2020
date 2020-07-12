module game.folders.word.folder_word_binary;

import game.folders.folder;
import game.folders.word.folder_word_readme;

class FolderWordBinary : Folder
{
    enum name = "CommonLanguage";

    this()
    {
        super(this.name);
    }

    override bool isFolderCompleted()
    {
        return this.foldersInCurrentDirectory().length > 0;
    }

    override void onFolderCompleted()
    {
        this.children[FolderWordReadme.name].visible = true;
    }

    override void onCreate()
    {
        this.createFiles();

        auto c = new FolderWordReadme();
        c.visible = false;
        this.addChild(c);
    }

    override void createFiles()
    {
        import std.stdio : File;

        File file;

        file = File(this.pathForFileInCurrentFolder("New Document.txt"), "w");
        file.write("01001110 01000101 01010111");
        file.close();

        file = File(this.pathForFileInCurrentFolder("New Document (2).txt"), "w");
        file.write("01000011 01010010 01000101 01000001 01010100 01000101");
        file.close();

        file = File(this.pathForFileInCurrentFolder("New Document (3).txt"), "w");
        file.write("01000110 01001111 01001100 01000100 01000101 01010010");
        file.close();

        file = File(this.pathForFileInCurrentFolder("SCAB.txt"), "w");
        file.write("Search. Cloud. ASCII. Binary.");
        file.close();
    }
}
