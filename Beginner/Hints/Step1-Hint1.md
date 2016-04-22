# Step 1, Hint 1  
You can find the appropriate installers under SCIS_Password_Lab/Lab/.Storage, or use the links in the [Beginner/Downloads](https://github.com/JonZeolla/Lab/tree/PasswordCracking/Beginner/Downloads) section of my GitHub.  The README under Beginner/Downloads may help point you at the exact file if you aren't clear (best viewed through a web browser).  

## Mac  
### Required  
1. Hashcat  
  * Decompress the password lists.  
    * `cd .Storage/Lists/`  
    * `open *.zip *.gz *.bz2`  
      * Requires a decompression app be installed, such as Keka.  
    * `open *tar`  
      * Requires a decompression app be installed, such as Keka.  
    * `cd ..`  
  * `open hashcat-2.00.7z`  
    * Requires a decompression app be installed, such as Keka.
  * `cd hashcat-2.00`  
2. Ruby  
  * A functioning version of Ruby is installed by default on Mavericks (10.9) and Yosemite (10.10) which should work for the software in this lab.  


## Windows  
### Required  
1. WinRAR  
  * `cd .Storage`  
  * `./winrar-x64-521.exe`  
    * Follow the instructions to install WinRAR, leaving the default settings.  
  * Decompress the password lists.  
    * `cd ./Lists`  
    * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ *.zip" ; Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ *.gz" ; Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ *.bz2"`  
      * If necessary, replace the location of WinRAR to where you selected to install it.   
  * Untar files  
    * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ -y *.tar"`  
  * `cd ..`  
2. Ruby
  * Install Ruby  
    * `.\rubyinstaller-2.2.3-x64.exe`  
      * Accept the license agreement then be sure to check "Add Ruby executables to your PATH" and "Associate .rb and .rbw files with this Ruby installation" before clicking Install.  
![Step1-Hint1_Windows_1.png](https://raw.githubusercontent.com/JonZeolla/Lab/PasswordCracking/Beginner/.Screenshots/Step1-Hint1_Windows_1.png)  
3. Hashcat  
  * If you have a NVIDIA GPU:  
    * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ cudaHashcat-2.01.7z" ; cd cudaHashcat-2.01`  
  * If you have an AMD GPU:  
    * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ oclHashcat-2.01.7z"; cd oclHashcat-2.01`  
  * If you have no discrete GPU or only want to use your CPU:
    * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -IBCK -o+ hashcat-2.00.7z" ; cd hashcat-2.00`  


## Linux  
### Required  
1. Hashcat  
  * Decompress the password lists.  
    * `cd .Storage/Lists/`  
    * `unzip -qq -n *.zip ; gunzip *.gz ; bunzip2 *.bz2`  
    * `tar -xvf *.tar`  
    * `cd ..`  
  * If you have a NVIDIA GPU:  
    * `7z x cudaHashcat-2.01 ; cd cudaHashcat-2.01`  
      * This assumes that p7zip is installed.  If it isn't run `sudo apt-get install p7zip`, `sudo yum install p7zip`, or another method to install p7zip as appropriate.  
  * If you have an AMD GPU:  
    * `7z x oclHashcat-2.01 ; cd oclHashcat-2.01`  
      * This assumes that p7zip is installed.  If it isn't run `sudo apt-get install p7zip`, `sudo yum install p7zip`, or another method to install p7zip as appropriate.  
  * If you have no discrete GPU or only want to use your CPU:  
    * `7z x hashcat-2.00.7z ; cd hashcat-2.00`  
      * This assumes that p7zip is installed.  If it isn't run `sudo apt-get install p7zip`, `sudo yum install p7zip`, or another method to install p7zip as appropriate.  
2. Ruby  
  * Debian or Ubuntu systems\*  
    * `sudo apt-get install ruby`  
  * CentOS, Fedora, or RHEL\*  
    * `sudo yum install ruby`  
  * Other options\*  
    * `sudo emerge dev-lang/ruby`  
    * `sudo pacman -S ruby`  

\* See the [installation page](https://www.ruby-lang.org/en/documentation/installation/) for more details.  

