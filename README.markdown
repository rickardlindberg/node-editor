**Node editor** is an experimental program that sees the world in terms of
nodes and children to nodes. It let's you edit the nodes and thereby edit the
world by looking at it from a different angle.

# Pomodoros

Work is done in pomodoros. What is done in each pomodoro is documented below.

## #7 (24 June 2013): Extract node functionality to separate module

## #6 (24 June 2013): Flesh out display -> edit -> display cycle

## #5 (17 June 2013): Write regression test using pdiff

## #4 (17 June 2013): Write regression test using pdiff

## #3 (17 June 2013): Write regression test using pdiff

## #2 (17 June 2013): Work on first story

* Copied GTK code from another project (codemonitor)
* Needed to install GTK
    * yum install gtk2-devel
    * cabal install gtk2hs-buildtools
    * cabal install gtk

## #1 (17 June 2013): Figure out first story

Brainstorm requirements:

* Edit body of nodes in external program

* Edit header of nodes
* Edit node relationships

* Show nodes in tree
* Show preview of body

Story: Edit body of node in external program

1. Open editor with default node
    * Default node is a file node (this README file)
        * Header is file name
        * Body is contents of file
    * Header shows in left pane
    * Body shows in right pane
2. Press something to edit node in external program
3. Edit, save, and exit in external program
    * Body is updated in right pane

**Extra work in this pomodoro**:

* Wrote README
* Created and published git repository
