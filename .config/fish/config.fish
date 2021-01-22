set -x TERMINAL alacritty
set -x EDITOR vim

set -x LIBVA_DRIVER_NAME iHD 

alias yuview="~/Software/YUView/YUViewApp/YUView"
alias matlab="~/Software/Matlab2019a/bin/matlab"
#alias rdplot="PYTHONPATH=~/Software/RDPlot/src/ python ~/Software/RDPlot/src/rdplot/__main__.py"
alias code="code --disable-gpu"
alias gitdotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME' 

alias l="ls -l"
alias mv="mv -i"
alias rm="rm -i"

#xmodmap -e "keycode 44 = j J Left Left Left dead_horn dead_hook"
#xmodmap -e "keycode 45 = k K Down Down Down ampersand kra"
#xmodmap -e "keycode 46 = l L Right Right Right Lstroke lstroke"
#xmodmap -e "keycode 31 = i I Up Up Up idotless rightarrow"
#xmodmap -e "keycode 33 = p P Prior Prior Prior"
#xmodmap -e "keycode 47 = odiaeresis Odiaeresis Next Next  Next"
#xmodmap -e "keycode 30 = u U Home Home Home"
#xmodmap -e "keycode 32 = o O End End End"
#xmodmap -e "keycode 43 = h H Delete Delete Delete"
#xmodmap -e "keycode 66 = Mode_switch"

set -x PATH /home/urbi/.local/bin $PATH

set -x PATH /home/urbi/perl5/bin $PATH
set -x PERL5LIB /home/urbi/perl5/lib/perl5 $PERL5LIB
set -x PERL_LOCAL_LIB_ROOT /home/urbi/perl5 $PERL_LOCAL_LIB_ROOT
set -x PERL_MB_OPT "--install_base \"/home/urbi/perl5\""
set -x PERL_MM_OPT "INSTALL_BASE=/home/urbi/perl5"

set -x PATH /usr/bin/vendor_perl/ $PATH

set -x export QT_AUTO_SCREEN_SCALE_FACTOR 1

if ping -c 1 -q host1 &> /dev/null
    set -Ux CUPS_SERVER "host1:631"
end

#starship init fish | source
