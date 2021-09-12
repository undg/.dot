# Setup fzf
# ---------
if [[ ! "$PATH" == */home/undg/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/undg/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/undg/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/undg/.fzf/shell/key-bindings.bash"
