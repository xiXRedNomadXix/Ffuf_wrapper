# Vhost Enumeration Script
I got tired of remembering the ffuf syntax for vhost fuzzing so just scripted it and got carried away with ASCII art. Looks cool though!

# Installation

Install dependancies:
```bash
sudo apt install ffuf seclists
```
this should install SecLists in the right place but if not, just move them to `/usr/share/wordlists/`
Clone this repository
```bash
git clone https://github.com/xiXRedNomadXix/Ffuf_wrapper.git
```
Change into the "Ffuf_wrapper" directory and make the script executable.
```bash
cd Ffuf_wrapper
chmod +x ffuf_wrapper.sh
```
Now you can either make a bash alias for the script, run it as is or symlink it. =) Happy huning!

![image](https://github.com/user-attachments/assets/041437e0-6729-4428-bf7b-4b0c11d69d37)
