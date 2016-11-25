#! /usr/local/bin/fish
#
# Fish shell that generates symlinks to all the sites
#
# v1.0 - 25 Nov 2016
#
# Let's configure some vars
#
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
######## I suggest you stop editing unless you know what you are doing. ########


# symlinks cleanup
function symlinks_cleanup
		switch $REMOVEONUP
			case 'yes'
	    		# yep, we should remove..
	    		set_color green
	    		echo "[*] Removing symlinks from $MAINDIR/$SITESDIR"
	    		set_color normal
	    		find $MAINDIR/$SITESDIR -type l -delete
	    	case '*'
	    		# nah, let's keep em.
	    		set_color yellow
	    		echo "[*] Not removing any symlinks, manual cleanup might be in order"
	    		set_color normal
	    end
end
# Let's make sure the folder exists
if test -d $MAINDIR/$SITESDIR
	set_color green
	echo "[*] Folder $MAINDIR/$SITESDIR exists, running cleanup.."
	set_color normal
	symlinks_cleanup
else
	set_color green
	echo "[*] Folder $MAINDIR/$SITESDIR doesn't exist, creating it."
	mkdir -p $MAINDIR/$SITESDIR
	set_color normal
end

for folder in (ls $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR)
	# Let's check for the domain,
	if test -e $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/vvv-hosts
		# Yup, the domain file exists, let's continue..
		# Since, some domains might contain a comment, let's make sure
		# we actually remove the comments from the file..
		# Huge thanks for the grep (bash only) to
		# http://kvz.io/blog/2007/07/11/cat-a-file-without-the-comments/
		# original: egrep -v "^\s*(#|$)"
		set -l DOMAIN_NAME (cat $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/vvv-hosts | egrep -v "^\s*(#|%self)")
			if test (count $DOMAIN_NAME) -gt 1
				# Looks like we hit a folder/domain
				# that houses two domains, let's go through each..
				# ln -s 0_GitProjects/vagrant-hennik/www/ site
				for i in $DOMAIN_NAME
					# echo "(MULTIPLE DOMAINS): $i exists in folder $folder"
					echo "Trying to link $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/htdocs/ to $MAINDIR/$SITESDIR/$i"
					ln -s $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/htdocs/ $MAINDIR/$SITESDIR/$i
				end
				# echo "(MULTIPLE DOMAINS): $DOMAIN_NAME[0] exists in folder $folder"
				# echo "(MULTIPLE DOMAINS): $DOMAIN_NAME[2] exists in folder $folder"
				else
				# echo "$DOMAIN_NAME exists in folder $folder"
				echo "Trying to link $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/htdocs/ to $MAINDIR/$SITESDIR/$DOMAIN_NAME"
				ln -s $MAINDIR/$VAGRANTDIR/$VAGRANTWWWDIR/$folder/htdocs/ $MAINDIR/$SITESDIR/$DOMAIN_NAME

			end
		# echo "$DOMAIN_NAME[1] exists in folder $folder"
	end
end
set_color green
echo "[*] Symlinks created.."
set_color normal