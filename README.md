# vvv-symlinks
### [*fish*](https://github.com/fish-shell/fish-shell) script, that automatically generates symlinks in a specific directory when [vagrant](https://github.com/Varying-Vagrant-Vagrants/VVV) is run.

The script needs some manual changes to the `Vagrantfile` so that it's actually able to work.

To get started, clone this repository into a folder in your ***vagrant*** folder.

For example:

```
cd vagrant
git clone https://github.com/niladam/vvv-symlinks.git utils
```

* Stop your vagrant using

`vagrant halt`

Next, edit your `Vagrantfile` using your preferred code/text editor.

If you cloned the repo into a folder called ***utils*** as instructed above you can do the following:

* Open up `Vagrantfile`

Right before the last ```end``` add:

```ruby
  if File.exists?(File.join(vagrant_dir,'utils','symlinks.fish')) then
    config.trigger.after :up do
      run '/usr/local/bin/fish' + ' ' + File.join(vagrant_dir,'utils','symlinks.fish')
    end
  end
```

Replacing ***/usr/local/bin/fish*** with the ouput of the command:

`which fish`

If you have cloned into a folder named anything else than ***utils*** make sure you update the `utils` word on the line `if File.exists?(File.join(vagrant_dir,'utils','symlinks.fish')) then` and on the line `run '/usr/local/bin/fish' + ' ' + File.join(vagrant_dir,'utils','symlinks.fish')` to match your folder.

* Open up `utils/symlinks.fish` in your favourite code/text editor and edit the variables at the top of the script:

```bash
# As a general rule, please make sure you DO NOT USE SPACES in directories.
#
# MAINDIR usually under $HOME -- but you can tweak this to your liking
# If you don't know how to change this i suggest you leave it as is and
# make sure that VAGRANTDIR matches your actual location
#
set MAINDIR			$HOME
#
# The VAGRANTDIR should be the folder where you have vagrant installed.
# Personally, i handle this by creating a symlink in my homedir for quick
# access to it (ln -s /path/to/vagrant $HOME/vagrant)
#
# NO TRAILING SLASHES -- as these are used in the script.
#
set VAGRANTDIR		"vagrant"
#
# The VAGRANTWWWDIR is by default www, but someone might actually want
# to tweak this to suit their needs..
#
# NO TRAILING SLASHES -- as these are used in the script.
#
set VAGRANTWWWDIR	"www"
#
# The SITESDIR should reflect where you want your links to exist.
# Personally i use a folder called sites under my home directory
# (mkdir $HOME/sites)
#
#
# If the folder does not exist, it WILL BE CREATED upon firing up the script
#
# NO TRAILING SLASHES -- as these are used in the script.
#
set SITESDIR		"sites"
#
# The REMOVEONUP variable instructs the script to
# remove all symlinks in SITESDIR when vagrant is starting.
# Basically this makes sure that if a site is removed between up/halt
# a link to it should no longer exist
# Should we remove the links when the vagrant machine starts?
# accepted values: yes/no (default value is yes)
#
# yes = upon vagrant up all symlinks in the SITESDIR are removed.
# no  = upon vagrant up no symbolic links are remove from SITESDIR
#
#
set REMOVEONUP		"yes"
```