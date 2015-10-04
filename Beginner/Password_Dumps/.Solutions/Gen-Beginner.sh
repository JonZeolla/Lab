#!/bin/bash

## Create Dump1-Beginner.txt (unsalted sha1)

# Derive the list of passwords from the password lists
for x in `find ../ -maxdepth 1 -type f`; do
    shuf -n 1100 "${x}" >> Dump1-Beginner-Plaintext.txt
done

# Unique the list and shuffle them
sort -u Dump1-Beginner-Plaintext.txt | shuf >> Dump1-Beginner-Plaintext.txt2
mv Dump1-Beginner-Plaintext.txt2 Dump1-Beginner-Plaintext.txt

# Clean up the carriage returns
cat Dump1-Beginner-Plaintext.txt | col -b >> Dump1-Beginner-Plaintext.txt2
mv Dump1-Beginner-Plaintext.txt2 Dump1-Beginner-Plaintext.txt

# Remove blank lines
sed -i '/^$/d' Dump1-Beginner-Plaintext.txt

# Hash the passwords
while read line; do
    echo -n "${line}" | openssl dgst -sha1 | awk '{print $NF}' >> Dump1-Beginner.txt
done < Dump1-Beginner-Plaintext.txt

# Add headers
sed -i '1ipasswords' Dump1-Beginner-Plaintext.txt
sed -i '1ipasswords' Dump1-Beginner.txt


## Create Dump2-Beginner.txt (salted sha1)

# Derive the list of passwords from the password lists
for x in `find ../ -maxdepth 1 -type f`; do
    shuf -n 1100 "${x}" >> Dump2-Beginner-Plaintext.txt
done

# Unique the list and shuffle them
sort -u Dump2-Beginner-Plaintext.txt | shuf >> Dump2-Beginner-Plaintext.txt2
mv Dump2-Beginner-Plaintext.txt2 Dump2-Beginner-Plaintext.txt

# Clean up the carriage returns
cat Dump2-Beginner-Plaintext.txt | col -b >> Dump2-Beginner-Plaintext.txt2
mv Dump2-Beginner-Plaintext.txt2 Dump2-Beginner-Plaintext.txt

# Remove blank lines
sed -i '/^$/d' Dump2-Beginner-Plaintext.txt

# Generate a salt, store it in the file, and hash the passwords with the salt
while read line; do
    salt=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'A-Za-z0-9' | fold -w 16 | head -1)
    echo -n "${salt}," >> Dump2-Beginner.txt
    echo -n "${salt}${line}" | openssl dgst -sha1 | awk '{print $NF}' >> Dump2-Beginner.txt
done < Dump2-Beginner-Plaintext.txt

# Add headers
sed -i '1ipasswords' Dump2-Beginner-Plaintext.txt
sed -i '1isalt,passwords' Dump2-Beginner.txt

