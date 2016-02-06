# Lab Materials  
This is the repo where I host **branches** which **have the materials** used during events, presentations, labs, etc.  Additionally, I create **tags** to point to the specific version of a branch which was used for a particular event or presentation.  
  
The reason I do this is so that you do not need to download all of the labs just to get the one that you're interested in (see below for an example of how to do this).  Some labs are rather large, and someone may want to retrieve a branch in locations where Internet connections are slow.  
  
**In order to use this repo as intended, you MUST switch to the appropriate branch**, via the web UI or CLI.  See `git branch -r` and `git checkout -b <remote>` to list and then checkout the appropriate branch via the command line.  In the web UI, use the dropdown directly to the left of the "New pull request" button to select a specific branch or tag.  
  
Examples:  
* `git clone -b SoftwareDefinedRadio --single-branch https://github.com/JonZeolla/Lab`  
  * Clone the latest revision of the SoftwareDefinedRadio branch.  
* `git clone -b 2015-09-24_SCIS_PasswordCracking --single-branch https://github.com/JonZeolla/Lab`  
  * Clone the revision of the PasswordCracking branch used during the 2015-09-24 Steel City InfoSec lab.  Cloning any of the pointers (tags) will put you in a detached HEAD state, which is expected.  
