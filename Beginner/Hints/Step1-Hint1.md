# Step 1, Hint 1  
You can find the appropriate installers under SCIS_Password_Lab/Presentation_Materials/.Storage, or use the links in the [Beginner/Downloads](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/Beginner/Downloads) section of my GitHub.  The README under Beginner/Downloads may help point you at the exact file if you aren't clear (best viewed through a web browser).  

## Mac  
### Required  
1. Hashcat  
  * Decompress the password lists.  
    * `cd .Storage/Lists/`  
    * `open *.zip *.gz *.bz2 *.7z`  
      * Requires a decompression app be installed, such as Keka.  
    * `open *tar`  
      * Requires a decompression app be installed, such as Keka.  
    * `cd ..`  
  * `open hashcat-0.50.7z`  
    * Requires a decompression app be installed, such as Keka.
  * `cd hashcat-0.50`  
2. Ruby  
  * The correct version of Ruby is already installed on Mavericks (10.9) and Yosemite (10.10).  

### Optional  
1. Determine your type of graphics card if you intend to make use of it.  
![Step1-Hint1_Mac_1.png](https://raw.githubusercontent.com/JonZeolla/Presentation_Materials/Password-Cracking_2015-09-24/Beginner/.Screenshots/Step1-Hint1_Mac_1.png)  
![Step1-Hint1_Mac_2.png](https://raw.githubusercontent.com/JonZeolla/Presentation_Materials/Password-Cracking_2015-09-24/Beginner/.Screenshots/Step1-Hint1_Mac_2.png)  
2. `cd ..`  
3. `unzip gfxCardStatus-2.3.zip`  
4. `open gfxCardStatus.app`  
5. Set the card to Discrete only in order to make use of your GPU during Hashcat cracking.  
![Step1-Hint1_Mac_3.png](https://raw.githubusercontent.com/JonZeolla/Presentation_Materials/Password-Cracking_2015-09-24/Beginner/.Screenshots/Step1-Hint1_Mac_3.png)  
6. Move back into the hashcat folder  
  * `cd hashcat-0.50`  


## Windows  
### Required  
1. WinRAR  
  * `cd .Storage`  
  * `./winrar-x64-521.exe`  
    * Follow the instructions to install WinRAR, leaving the default settings.  
  * `cd ./Lists`  
  * `Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -df -IBCK -y *.zip .\" ; Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -df -IBCK -y *.gz .\" ; Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -df -IBCK -y *.bz2 .\" ; Start-Process -FilePath "C:\Program Files\WinRAR\WinRAR.exe" -ArgumentList "x -df -IBCK -y *.7z .\"`  
    * If necessary, replace the location of unrar to where you selected to install it.  
  * `cd ../..`  
2. Hashcat  
  * Decompress the password lists.  
    * `cd .Storage/Lists/`  
TODO:  Add the correct Windows command(s)  
  * If you have an NVIDIA card, `open cudaHashcat-1.37` otherwise `open oclHashcat-1.37`  
    * Requires a decompression app be installed, such as Keka.  
  * If you have an NVIDIA card, `cd cudaHashcat-1.37` otherwise `cd oclHashcat-1.37`  
3. Ruby  
  * Install [Ruby - v2.2.3](https://github.com/JonZeolla/Presentation_Materials/tree/Password-Cracking_2015-09-24/.Storage/rubyinstaller-2.2.3-x64.exe)  

## Linux  
### Required  
1. Hashcat  
  * Decompress the password lists.  
    * `cd .Storage/Lists/`  
TODO:  Add the correct Linux command(s)  
  * If you have an NVIDIA card, `open cudaHashcat-1.37` otherwise `open oclHashcat-1.37`  
    * Requires a decompression app be installed, such as Keka.  
  * If you have an NVIDIA card, `cd cudaHashcat-1.37` otherwise `cd oclHashcat-1.37`  
2. Ruby  
  * Debian or Ubuntu systems\*  
    * `sudo apt-get install ruby`  
  * CentOS, Fedora, or RHEL\*  
    * `sudo yum install ruby`  
  * Other options\*  
    * `sudo emerge dev-lang/ruby`  
    * `sudo pacman -S ruby`  
\* See the [installation page](https://www.ruby-lang.org/en/documentation/installation/) for more details.  

