# Lab Materials (deprecated)  
This is the repo where I **used to host** branches which have the materials used during events, presentations, labs, etc.  However, **starting on 2016-12-03 I began a project to migrate these materials to standalone repositories**.  The [releases](https://github.com/JonZeolla/Lab/releases) will continue to exist here for maintenance reasons, but no new releases or updates will be made to this location.  Please refer to the new location for the most updated materials.

## Status
As of 2016-01-01, this is the status of the migration  

| Previous Branch | Future Repository | Status |
| -------------- | ----------------- | ------ |
| [AudioSurveillance](https://github.com/JonZeolla/Lab/tree/AudioSurveillance) | [lab-LaserMicrophones](https://github.com/JonZeolla/lab-LaserMicrophones) | Complete |
| [WLANSecurity](https://github.com/JonZeolla/Lab/tree/WLANSecurity) | [lab-WifiSecurity](https://github.com/JonZeolla/lab-WifiSecurity) | Complete |
| [AutomotiveSecurity](https://github.com/JonZeolla/Lab/tree/AutomotiveSecurity) | [lab-AutomotiveSecurity](https://github.com/JonZeolla/lab-AutomotiveSecurity) | Complete |
| [DropBoxes](https://github.com/JonZeolla/Lab/tree/DropBoxes) | [lab-DropBoxes](https://github.com/JonZeolla/lab-DropBoxes) | Complete |
| [InternetofInsecurity](https://github.com/JonZeolla/Lab/tree/InternetofInsecurity) | [lab-InternetofInsecurity](https://github.com/JonZeolla/lab-InternetofInsecurity) | Complete |
| [PasswordCracking](https://github.com/JonZeolla/Lab/tree/PasswordCracking) | lab-PasswordCracking | Not Started |
| [ProximityAttacks](https://github.com/JonZeolla/Lab/tree/ProximityAttacks) | lab-ProximityAttacks* | Not Started |
| [SoftwareDefinedRadio](https://github.com/JonZeolla/Lab/tree/SoftwareDefinedRadio) | lab-SoftwareDefinedRadio | Not Started |

\* After migration, this should be split into separate labs for RFID, Mag Stripe, NFC, etc.

## How to use this repo

In order to use this repo as intended, you MUST switch to the appropriate branch, via the web UI or CLI. See `git branch -r` and `git checkout <remote>` to list and then checkout the appropriate branch via the command line. In the web UI, use the dropdown directly to the left of the "New pull request" button to select a specific branch or tag.

For materials that still solely exist here, please use the following methods for retrieval and updating:  
* `git clone -b SoftwareDefinedRadio --single-branch --recursive https://github.com/JonZeolla/Lab`  
  * Clone the latest revision of the SoftwareDefinedRadio branch.  
* `git clone -b 2015-09-24_SCIS_PasswordCracking --single-branch --recursive https://github.com/JonZeolla/Lab`  
  * Clone the revision of the PasswordCracking branch used during the 2015-09-24 Steel City InfoSec lab.  Cloning any of the pointers (tags) will put you in a detached HEAD state, which is expected.  
* `Branch=newbranch;git clone https://github.com/JonZeolla/lab;cd lab;git checkout --orphan $Branch;git rm --cached -r .;echo "Initial creation of $Branch" > README.md;git add README.md;git commit -m "Initial creation of $Branch";git push origin $Branch;unset Branch`  
  * Clone the Lab repository, create an orphan branch called newbranch, clear the working directory, create a standard initial README.md, and then push it back up to the remote under the branch newbranch.  
* `git push origin PasswordCracking`  
  * Push updates to the PasswordCracking branch.  
* `git push origin --delete newbranch`  
  * Delete the remote branch newbranch.  
