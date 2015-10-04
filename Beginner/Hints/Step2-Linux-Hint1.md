# Step 2, Linux, Hint 1  

## Step 2
Crack the [Beginner Password Dumps](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Password_Dumps) located under locally under SCIS_Password_Lab/Presentation_Materials/Beginner/Password_Dumps.

### Linux
1. Combine Hashcat and the password files available under SCIS_Password_Lab/Presentation_Materials/.Storage to crack Dump1 (Don't forget to use your web brower and check out [Beginner/Downloads](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Downloads)).
  * `cd SCIS_Password_Lab/Presentation_Materials/.Storage/`
  * `cd hashcat-0.50`
  * `./hashcat-cli64.bin -m 100 ../../Beginner/Password_Dumps/Dump1-Beginner.txt ../Lists/*.txt`
    * This should recover 45990/47216 (97%) of the hashes
    * Attempt various uses of `hashcat-cli64.bin` using different password files, etc.

2. Combine Hashcat and the password files available under SCIS_Password_Lab/Presentation_Materials/.Storage to crack Dump1 (Don't forget to use your web brower and check out [Beginner/Downloads](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Downloads)) to reconfigure and crack the second dump.
  * `awk -F\, '{ OFS=":"; print $2,$1}' ../../Beginner/Password_Dumps/Dump2-Beginner.txt >> ../../Beginner/Password_Dumps/Dump2-Beginner-Reformatted.txt`
  * `./hashcat-cli64.bin -m 120 ../../Beginner/Password_Dumps/Dump2-Beginner-Reformatted.txt ../Lists/*.txt`

