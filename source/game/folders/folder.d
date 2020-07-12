module game.folders.folder;

import game.misc;
import std.file : DirEntry;
import std.array : array;
import std.algorithm;
import game.player;
import std.experimental.logger : sharedLog;

class Folder
{
    string name;
    bool visible;
    bool inited;
    bool corrupt;
    Folder parent;
    Folder[string] children;

    this(string name, bool visible = true)
    {
        this.name = name;
        this.visible = visible;
    }

    string getFolderPath()
    {
        if (this.parent !is null)
        {
            return this.parent.getFolderPath() ~ "\\" ~ this.name;
        }

        return ".\\" ~ this.name;
    }
    
    private void setParent(Folder parent)
    {
        this.parent = parent;
    }

    Folder getChildWithName(string name)
    {
        assert((name in children) !is null);

        if ((name in children) is null)
        {
            return null;
        }

        return children[name];
    }

    bool hasChildWithName(string name)
    {
        return (name in this.children) !is null;
    }

    void addChild(Folder child)
    {
        this.children[child.name] = child;
        child.setParent(this);

        sharedLog.log("added child for parent", child.parent);
    }

/+
    bool isSameAs(Folder other)
    {
        if (this.children.keys != other.children.keys)
        {
            return false;
        }

        assert(this.children.keys == other.children.keys);
        foreach (string key; this.children.keys)
        {
            bool isChildrenCorrect = this.children[key].isSameAs(other.children[key]);
            if (!isChildrenCorrect)
            {
                return false;
            }
        }

        return true;
    }
+/

    bool isVisible()
    {
        return visible;
    }

    void setVisible(bool visible)
    {
        this.visible = visible;
    }

    bool isFolderCompleted()
    {
        return true;
    }

    void onFolderCompleted()
    {
        return;
    }

    void onEnterByPlayer()
    {
    }

    void onCreate()
    {
    }

    void onUpdate()
    {
    }

    void createFiles()
    {
    }

    auto gameFilesInCurrentDirectory()
    {
        return filesInFolder(this.getFolderPath()).filter!(a => a.filenameFromFilePath != Player.name).map!(file => file.name.filenameFromFilePath).array();
    }

    auto foldersInCurrentDirectory()
    {
        return foldersInFolder(this.getFolderPath()).map!(file => file.name.filenameFromFilePath).array();
    }

    string pathForFileInCurrentFolder(string filename)
    {
        return this.getFolderPath ~ "\\" ~ filename;
    }
}
