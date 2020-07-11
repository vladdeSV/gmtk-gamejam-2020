module game.folders.folder;

class Folder
{
    string name;
    bool visible = true;
    Folder parent;
    Folder[string] children;

    this(string name, bool visible = true)
    {
        this.name = name;
        this.visible = visible;
    }

    void onUpdate()
    {

    }

    void createFiles()
    {
    }

    string[] whitelistedFiles()
    {
        return [];
    }

    string getFolderPath()
    {
        if (this.parent !is null)
        {
            return this.parent.getFolderPath() ~ "\\" ~ this.name;
        }

        return ".\\" ~ this.name;
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

        import std.stdio;
        writeln("added child ", child.parent);
    }

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

    bool isVisible()
    {
        return visible;
    }

    void setVisible(bool visible)
    {
        if (visible)
        {
            createFiles();
        }

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

    void onCreate()
    {
    }

    private void setParent(Folder parent)
    {
        this.parent = parent;
    }
}
