# Johnny decimal helpers

## Purpose
This is a set of helpers for dealing with [Johnny Decimal](https://johnnydecimal.com/) system.
Includes a script/library to abtract useful operations, a mechanism to define and create your own hierarchies for the system and an example script to operate on files from the GUI.

## Usage
The script is very simple but requires some fixed structure:
- Leaf nodes of the JD system should include the fully qualified category number to be found, like this: *AA.CC*.
- Do no repeat numbers, as it will give un predictable results.
- You can repeat numbers if you use a JD inside a JD, like I do for my projects. Here my projects has the numbers 11.XX, for example my project "11.01 take over the world". This project will have its own JD structure, completely different from the parent. Also this same structure will be repeated in every project to allow me to memorize where is everything in every project. This works well for me but your mileage may vary.
- I'm using a method to allow me to create defaults for any JD number by using an "info.yaml" file on the root directory of the category. The `jdlibrary.sh` operations are aware of this fact, can help you to define this file and also use it to operate. This fact allows me to have a default operation/file/URL for each category. I find this most useful and let me illustrate with an example: Say that all my projects has a JD number `30.04 Execution` where I store all information related to project execution like status meeting notes, documentation generated in the development, etc. Now, say that I also have a Jira project that we use to manage this project. I add the url of this Jira board to the `info.yaml` on the root of the `30.04 Execution` folder. My thought process when I want to check on the project afterwards is: "The project X has the number 11.02 and I want to get the status of the execution which is always 30.04, so I need to ask for the default action on JD ID 11.02.30.04". At least for me is very easy to remember.

## Install

### Prerequisites
- pip install yamldirs
- Install https://github.com/mikefarah/yq (beware there is another yq in python, this one is in go)
- Install zenity for the GUI app (optional)

### Installing
- Place the script `jdlibrary.sh` somewhere in your path.
- Create your JD hierarchy - see help below
- Adjust variables on top of `jdlibrary.sh` if not using the defaults.
- There is no step 4.

### How to create your JD hierarchy

Copy the example .yamls from the `cjnumeric` folder to the folder that will contain your system (I use ~/JD) and edit as desider. Then execute `yamldirs <filename.yaml>` and watch your complete hierarchy being created.