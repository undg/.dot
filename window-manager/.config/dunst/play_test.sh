    #!/bin/sh

    SCRIPT_PATH="/home/undg/.config/dunst/play.sh"
    IGNORED_APP="Spotify"

    if sh "$SCRIPT_PATH" "Spotify"; then
      echo "Test failed: Spotify should be ignored."
    else
      echo "Test passed: Spotify is correctly ignored."
    fi

    if sh "$SCRIPT_PATH" "NonIgnoredApp"; then
      echo "Test passed: NonIgnoredApp is not ignored as expected."
    else
      echo "Test failed: NonIgnoredApp should not be ignored."
    fi
