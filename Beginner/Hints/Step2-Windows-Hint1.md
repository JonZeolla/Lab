# Step 2, Windows, Hint 1  

## Step 2
Crack the [Beginner Password Dumps](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Password_Dumps) located under locally under SCIS_Password_Lab/Presentation_Materials/Beginner/Password_Dumps.  

### Windows
1.  Use Hashcat and the password files available under SCIS_Password_Lab/Presentation_Materials/.Storage (Don't forget to use your web brower and check out [Beginner/Downloads](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Downloads)) to crack the first dump.  
  * `./hashcat-cli64.exe -m 100 ../../Beginner/Password_Dumps/Dump1-Beginner.txt ../Lists/*.txt`  
    * This should recover 43458/50617 (86%) of the hashes  
    * Attempt various uses of `hashcat-cli64.app` using different password files, etc.  
2.  Use Hashcat and the password files available under SCIS_Password_Lab/Presentation_Materials/.Storage (Don't forget to use your web brower and check out [Beginner/Downloads](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Downloads)) to reconfigure and crack the second dump.  
  * `Get-Content ../../Beginner/Password_Dumps/Dump2-Beginner.txt | %{ $col=$_.Split(',') ; $output=$col[1]; $output+=":"; $output+=$col[0] ; $output } | out-file -filepath ..\..\Beginner\Password_Dumps\Dump2-Beginner-Reformatted.txt -encoding ascii`  
  * `.\hashcat-cli64.exe -m 120 ..\..\Beginner\Password_Dumps\Dump2-Beginner-Reformatted.txt ..\Lists\*.txt`  

