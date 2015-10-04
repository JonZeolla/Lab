#!/bin/bash

## Create Dump1-Competition.txt (bcrypt 4)

# Derive the list of passwords from the password lists
for x in `find ../ -maxdepth 1 -type f`; do
    shuf -n 500 "${x}" >> Dump1-Competition-Plaintext.txt
done

# Unique the list and shuffle them
sort -u Dump1-Competition-Plaintext.txt | shuf >> Dump1-Competition-Plaintext.txt2
mv Dump1-Competition-Plaintext.txt2 Dump1-Competition-Plaintext.txt

# Clean up the carriage returns
cat Dump1-Competition-Plaintext.txt | col -b >> Dump1-Competition-Plaintext.txt2
mv Dump1-Competition-Plaintext.txt2 Dump1-Competition-Plaintext.txt

# Remove blank lines
sed -i '/^$/d' Dump1-Competition-Plaintext.txt

# Add headers
sed -i '1ipasswords' Dump1-Competition-Plaintext.txt

# Add web content
ruby cewl.rb meetup.com/steel-city-infosec -o -w SCIS.txt
echo SCIS.txt >> Dump1-Competition-Plaintext.txt

# Hash with bcrypt 4
# bcrypt-tool is available at https://github.com/shoenig/bcrypt-tool
while read line; do
    ./bcrypt-tool hash "${line}" 4 >> ../Competition/Password_Dumps/Dump1-Competition.txt
done < ../Competition/Password_Dumps/.Solutions/Dump1-Competition-Plaintext.txt

