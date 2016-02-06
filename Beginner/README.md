# Password cracking - Beginner  

Hints for each step are provided at [Beginner/Hints](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Hints).  


## Step 0  
1. Clone the Password Cracking branch by running the following command.  
  * If you haven't created an account, go to https://github.com/join.  
  ```
  mkdir SCIS_Password_Lab ; cd SCIS_Password_Lab ; git clone -b PasswordCracking --single-branch https://github.com/JonZeolla/Lab ; cd Lab ; cd Beginner
  ```
2. If you plan to use Windows, ensure that you have the Git Shell installed (comes coupled with [GitHub Desktop](https://desktop.github.com/)), which is where you will run future commands.  


## Step 1  
Ensure the following software has been installed.  
* You can find the appropriate installers locally under SCIS_Password_Lab/Lab/.Storage, or use the links in the [Beginner/Downloads](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Downloads) section of my GitHub.  The README under [Beginner/Downloads](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Downloads) may help point you at the exact file if you aren't clear (best viewed through a web browser).  

### Mac  
* Hashcat  
* Ruby  

### Windows  
* Hashcat  
* Ruby  
* WinRAR  
* iconv

### Linux  
* Hashcat  
* Ruby  


## Step 2  
Crack the two [Beginner Password Dumps](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Password_Dumps), also located locally under SCIS_Password_Lab/Lab/Beginner/Password_Dumps.  

### All OSs  
1. Combine Hashcat and the password lists available under SCIS_Password_Lab/Lab/.Storage/Lists (Don't forget to use your web brower and check out [Beginner/Downloads](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Downloads)) in order to crack the password dump.  


## Step 3  
Improve on your cracking speeds by auditing the results of Step 2.  

### All OSs  
1.  Run [PassPal.rb](https://github.com/JonZeolla/Lab/blob/PasswordCracking/.Storage/passpal.rb) which can be used to speed up the time it takes to crack the dump and better understand the data.  


Good luck!  

