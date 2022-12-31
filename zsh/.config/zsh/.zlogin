# Executes commands at login post-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!


# Print a static or dynamic, hopefully interesting, adage.
# First "if installed" win [unix, fortune, archey3]
if (( $+commands[unix] )); then
  if [[ -t 0 || -t 1 ]]; then
    unix
    print
  fi
elif (( $+commands[fortune] )); then
  if [[ -t 0 || -t 1 ]]; then
    fortune -s
    print
  fi
elif (( $+commands[archey3] )); then
  if [[ -t 0 || -t 1 ]]; then
    archey3 -c red
    print
  fi
fi
