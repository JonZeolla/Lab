# Writing to the CAN bus via CLI  
## Preparations  
Make sure you are in the vircar directory, which should be located in `${HOME}/Desktop/Lab/external/vircar/`  

## `vircar`  
Run the following command to start up the virtual car  
`/usr/bin/sudo ./vircar`  
If you get the error message `RTNETLINK answers: File exists`, you've already run vircar once and the interface still exists.  Although it should not cause an issue, you can delete the interface and get a clean start by either deleting the interface using  
`/usr/bin/sudo ip link delete vircar`  
or you can "blow the car up", which is a bit funner.  Do that by running  
`sudo ./vircar k`  

## `vircar-fuzzer`  
`vircar-fuzzer` is a ruby script written by the author of `vircar`, which was meant to do some fuzzing and brute forcing of the virtual `vircar`, in order to prove a point.  Something similar could be done for real cars, although it would be much more expensive if you were successful =)  
  
In order to run `vircar-fuzzer`, ensure you are in `${HOME}/Desktop/Lab/external/vircar` and run  
`ruby ../vircar-fuzzer/src/vircar-fuzzer.rb`  
This script essentially is a wrapper for `cangen` and allows for slightly more directed fuzzing using `vircar-fuzzer/src/frames` as an input  

