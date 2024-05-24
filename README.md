![Version](https://img.shields.io/static/v1?label=crafted-emacs-config&message=0.2&color=brightcolor)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


# Configuration file for crafted-emacs

Dave Wilson, Jeff Bowman, and others have built [crafted-emacs](https://github.com/SystemCrafters/crafted-emacs).
This is an Emacs profile that tries to maximize the use of Emacs' built-in features while minimizing the use of packages.
Crafted-emacs is a framework on which to build further customizations.
The framework is feature-rich enough  with the essentials to save you a lot of time.
I became productive with this profile faster than with most other configurations.

However, I still think it is for advanced beginners and beyond.
You need some experience with configuration files: probably more experience than is required to use a profile like scimax where many packages that an academic needs are built-in.
I cannot compare it to Doom or Spacemacs because I have not invested sufficient effort in mastering them.
However, with minimal effort, you can have a *Dave Wilson-like* environment up and running with your favorite configurations on top of it in several hours.
I really like it!

## User configuration

The user configuration file is called *config.el*.
It resides in the top level of the `.crafted-emacs` folder.
My variant of this file is contained in this repo.
The configuration of crafted-emacs is divided into a set of files called modules.
The top of the  *config.el* file loads selected modules.
The module files are stored in the modules subfolder.

You can comment out the modules that you do not need.
For example, you do not need to load the *crafted-python.el* python module if you are not a python programmer.
Likewise, you do not need to load the *crafted-latex.el* file for the latex module if you write only in markdown.
Also, you do not need to load the *crafted-evil.el* if you have mastered enough Emacs keybindings to free yourself from using Vim.
You could write your own module for a workflow that is not covered by the existing 23 modules.

The *crafted-completion.el* module uses the vertico, marginalia, orderless, embark, corfu, and cape stack of packages for autocompletion in place of ivy or helm.
These packages build on top of Emacs's built-in completion system rather than displace it with a separate system, as in the case of Ivy or Helm.
You can be one of the cool kids using this stack without having to install and configure each package separately.
Note that if you must use ivy or helm (say for compatibility with org-ref), then you will need comment out the *crafted-completions.el* file.

Below are the module calls for my keybindings, functions, and package configuration that I expect to be present.
For example, I bind `cmd` to the `Meta` key and `option` to the `Super` key.
I love using `C-right` and `C-left` to switch between buffers.
In addition, I use `M-up` and `M-down` to move lines up and down.
I also added some functions like *itemize* for converting markdown lists into itemized lists in LaTeX.

I copied over my configuration in *user.el* for scimax and the configuration for yasnippets from *init.el* in latex-emacs.
My configuration for org-agenda supports ten task files, so modify to suit your needs.
I added configuration for yasnippets.

## Use of my config.el

Clone this repo with `git clone https://github.com/MooersLab/crafted-emacs-config crafted-emacs-config` in your home directory.
Copy the config.el file to the `.crafted-emacs` folder.
Git pull future updates from `crafted-emacs-config`.


## Notes on the installation of crafted-emacs on a Mac

I had to install the JetBeans fonts on my Mac OS.
Now it has the look and feel of Dave Wilson's setup on System Crafters.
It has the Doom mode line that you might want to drop if you are coming from Gnu Emacs.

The user's configuration resides in the top directory of *~/.crafted-emacs* in *config.el*.
I copied over my configuration in *user.el* from scimax and the configuration for yasnippets from *init.el* in latex-emacs.
I created a link to my *snippets* folder in my *~/.emacs.default* profile.
Crafted-emacs uses a built-in snippet manager.
I do not have time to reformat my hundreds of yasnipppet snippets.
I have too much invested in yasnippets to abandon it right now, so I installed yasnippets.

## Packages that I installed

I installed the following:

- use-package (I know; I should have used straight, but I was in a hurry.)
- atomic-chrome (enables hooking up with GhostText to edit text areas in webpages.)
- language-tool
- org-pomodoro
- org-roam
- wc-mode (for displaying word counts in the modeline)
- yasnippets

## What is missing

- A crafted-bibtex module. I may have to install citar for handling BibTeX.

## Disclaimer

I am getting an error message on startup but the features of my config.el are working fine.

## Update history

|Version      | Changes                                                                                                                                                                         | Date                 |
|:-----------:|:------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------:|
| Version 0.2 |   Added badges, funding, and update table. Made numerous edits of the README.md file.                                                                                                                  | 2024 May 24          |


## Sources of funding

- NIH: R01 CA242845
- NIH: R01 AI088011
- NIH: P30 CA225520 (PI: R. Mannel)
- NIH: P20 GM103640 and P30 GM145423 (PI: A. West)
