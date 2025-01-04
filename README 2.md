# Qiime Workshop

Qiime2 (v2023.5) installation script for Alpine conda environment, with accompanying rollback script.


# 20230629 debrief notes with Metcalf Group

Setting a time for quick debrief from the workshop:
- What was good?
- What needs work?
- Where can our team find more ways to be proactive to Alpine or user difficulties?
 
Our team works hard to be proactive whenever possible. It helps us troubleshoot a bit quicker and build out scalable tools. Looking forward to brainstorming with your lab for our next iteration of tools!

We’ll capture some notes and add items to our projects list for future endeavors.
 
Thank you for the opportunity to work with your team on this workshop,
 
 
Current setup:
- Qiime setup using sbatch file
    - Edits bashrc
    - Uses conda to edit conda rc
    - Creates qiime2 conda environment in ~45 minutes using projects directory
    - Seems to take ~30 minutes using scratch directory.
- Qiime filght test script
    - Prints bashrc and condafc
    - Prints conda env list
    - Looks for 'qiime2' and provided success message.

 
Issues:
- Keeping environments consistent, verifying milestones. Especially with different potential user environments in play
- Alpine being functional:
    - Storage issues with /projects and /home
    - https://curc.statuspage.io//
    - Might not be on page though…
- Might be better to have people edit their own bashrc and condarc files instead of having in the sbatch script?
    - Can have 2 scripts 1 with bashrc/condarc and other with qiime install.
    - Have instructions in the first setup script through comments.
    - Add check to qiime install to confirm changes before starting install in a second script.
    - Should use the whole version name for the environment created by setup script.
    - User story: Run ‘sbatch xyz.sh’  or open and follow instructions to edit *rc files. Then run qiime zyx.sh to setup conda/installation.
- Speed of creation of environment
- No improvement ideas
- Speed of computation work?
- Having 5 cores for each user. Don't forget OS related cores in node requests.
- Fight-test script
- Add some logic, if you see this do this
- Didn't work if listed as qiime2 or qiime2-2023.5
- Should use the whole version name for the environment.
- Can we check for package files being there?
- How does conda verify pkg integrity with yaml list? Checksum, name?
- Is there a way a test, use of Alpine?
- Performance of storage.
- Ncat + dd + benchmark file? Job test?

 
Next class change is presentation formats?:
Parkinson on alpine
Galaxy for other test data set.
 
Future:
Single install to admin area? https://conda.io/projects/conda/en/latest/user-guide/configuration/admin-multi-user-install.html
Value in having it installed for each user. Should we have a microbiome tools folder with a central conda environment
Could also be a microbiome module. Module load qiime
Move to containers, future proof design
Not at this time
 
End of class, presentation review of computation resources and techniques
What are the types of things you are likely to run into.

# Internal notes

Trouble Installing packages in R Studio -- phyloc,biodiversityr.
Redirecting to single point of start for directory (/projects/$User/) and node (sinteractive or *) in the flight test script.
Protect util scripts or files avoding public write access.
Consideration of aliases ( .bashrs/ env variables), consider more copy paste code snippets or commands.


