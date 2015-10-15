# Step 3, Hint 1  

Improve on your cracking speeds by auditing the results of Step 2.  

## All OSs  
1.  Run [PassPal.rb](https://github.com/JonZeolla/Presentation_Materials/blob/master/Password-Cracking_2015-09-24/.Storage/passpal.rb) which can be used to speed up the time it takes to crack the dump and better understand the data.  
  * Ensure that the password file is UTF-8 encoded.  

### Convert files to UTF-8 encoding  
#### Mac  
1.  `iconv -f $(file -I <file.old> | awk -F\= '{print $NF}') -t utf-8 < <file.old> > <file.new>`  
  * For example:  
    * `iconv -f $(file -I Dump2-Beginner-Plaintext.txt | awk -F\= '{print $NF}') -t utf-8 < Dump2-Beginner-Plaintext.txt > Dump2-Beginner-Plaintext.txt2`  
    * `ruby passpal.rb ../Beginner/Password_Dumps/.Solutions/Dump2-Beginner-Plaintext.txt2`  

#### Windows  
1.  `iconv -f iso-8859-1 -t utf-8 <file>`  
  * For example:  
    * `iconv -f iso-8859-1 -t utf-8 Dump2-Beginner-Plaintext.txt`  
    * `ruby passpal.rb ../Beginner/Password_Dumps/.Solutions/Dump2-Beginner-Plaintext.txt2`  

#### Linux  
1.  `iconv -f $(file -I <file.old> | awk -F\= '{print $NF}') -t utf-8 < <file.old> > <file.new>`
  * For example:  
    * `iconv -f $(file -I Dump2-Beginner-Plaintext.txt | awk -F\= '{print $NF}') -t utf-8 < Dump2-Beginner-Plaintext.txt > Dump2-Beginner-Plaintext.txt2`
    * `cd ../../../.Storage/`   
    * `ruby passpal.rb ../Beginner/Password_Dumps/.Solutions/Dump2-Beginner-Plaintext.txt2`

