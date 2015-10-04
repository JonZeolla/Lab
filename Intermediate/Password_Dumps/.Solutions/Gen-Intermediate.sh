#!/bin/bash

## Create Dump1-Intermediate.txt (unsalted sha1)

# Derive the list of passwords from the password lists
for x in `find ../ -maxdepth 1 -type f`; do
    shuf -n 1100 "${x}" >> Dump1-Intermediate-Plaintext.txt
done

# Unique the list and shuffle them
sort -u Dump1-Intermediate-Plaintext.txt | shuf >> Dump1-Intermediate-Plaintext.txt2
mv Dump1-Intermediate-Plaintext.txt2 Dump1-Intermediate-Plaintext.txt

# Clean up the carriage returns
cat Dump1-Intermediate-Plaintext.txt | col -b >> Dump1-Intermediate-Plaintext.txt2
mv Dump1-Intermediate-Plaintext.txt2 Dump1-Intermediate-Plaintext.txt

# Remove blank lines
sed -i '/^$/d' Dump1-Intermediate-Plaintext.txt

# Hash the passwords
while read line; do
    echo -n "${line}" | openssl dgst -sha1 | awk '{print $NF}' >> Dump1-Intermediate.txt
done < Dump1-Intermediate-Plaintext.txt

# Add headers
sed -i '1ipasswords' Dump1-Intermediate-Plaintext.txt
sed -i '1ipasswords' Dump1-Intermediate.txt


## Create Dump2-Intermediate.txt (salted sha1)

# Derive the list of passwords from the password lists
for x in `find ../ -maxdepth 1 -type f`; do
    shuf -n 1100 "${x}" >> Dump2-Intermediate-Plaintext.txt
done

# Unique the list and shuffle them
sort -u Dump2-Intermediate-Plaintext.txt | shuf >> Dump2-Intermediate-Plaintext.txt2
mv Dump2-Intermediate-Plaintext.txt2 Dump2-Intermediate-Plaintext.txt

# Clean up the carriage returns
cat Dump2-Intermediate-Plaintext.txt | col -b >> Dump2-Intermediate-Plaintext.txt2
mv Dump2-Intermediate-Plaintext.txt2 Dump2-Intermediate-Plaintext.txt

# Remove blank lines
sed -i '/^$/d' Dump2-Intermediate-Plaintext.txt

# Generate a salt, store it in the file, and hash the passwords with the salt
while read line; do
    salt=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'A-Za-z0-9' | fold -w 16 | head -1)
    echo -n "${salt}," >> Dump2-Intermediate.txt
    echo -n "${salt}${line}" | openssl dgst -sha1 | awk '{print $NF}' >> Dump2-Intermediate.txt
done < Dump2-Intermediate-Plaintext.txt

# Add headers
sed -i '1ipasswords' Dump2-Intermediate-Plaintext.txt
sed -i '1isalt,passwords' Dump2-Intermediate.txt

