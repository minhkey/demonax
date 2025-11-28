#!/bin/bash

OLD_NUMBER=136
NEW_NUMBER=12

cd ~/Documents/demonax/game/npc/

for file in *.npc; do
    if grep -q "Outfit = ($OLD_NUMBER," "$file"; then
        echo "Found outfit in: $file"
        cp "$file" "$file.bak"
        sed -i "s/Outfit = ($OLD_NUMBER,/Outfit = ($NEW_NUMBER,/g" "$file"
        echo "  ✓ Replaced $OLD_NUMBER  with $NEW_NUMBER"
    fi
done

cd ~/Documents/demonax
echo "Done! Backup files created with .bak extension"

