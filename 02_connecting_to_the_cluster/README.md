If you have *any* issues with any of the steps below, feel free to ask Ollie (oliver.knight@charite.de) for help. You can also check out the BIH-CUBI cluster guide [here](https://bihealth.github.io/bih-cluster/) which may be helpful, too.

**1. Applying for an HPC user account**  

The below form must be filled in and forwarded to the named delegate (i.e. oliver.knight@charite.de)

```
- cluster: HPC 4 Research
- first name:
- last name:
- affiliation: Charite, Department of Gastroenterology
- institute email: # charite e-mail
- institute phone:
- user has account with
    - [ ] BIH
    - [x] Charite
    - [ ] MDC
- BIH/Charite/MDC user name: #this will be in the format surname+firstnameinitial without the plus
- duration of cluster access (max 1 year): 
- AG: ag-romagnani
```

This will then be fowarded to hpc-gatekeeper@bihealth.de with you and Chiara in cc.

**2. Creating a secure shell (ssh) key**

a. Open terminal and type  
```Get-Service -Name ssh-agent | Set-Service -StartupType Manual```  

b. Type  
```ssh-keygen -t rsa -C "your_email@charite.de"``` # the quotation marks here stay in, they name your ssh key for future reference  

c. Use the default location for storing your ssh key, and type any secure password in to store it.  

d. Locate the ```.ssh/id_rsa.pub``` file in your file explorer and open with notepad. You may need to enable the 'show hidden files and folders' setting in your control panel.  

e. Copy the contents; it should look something like  
```ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/Rdd5rvf4BT38jsBlRrXpd1KDvjE1iZZlEmkB6809QK7hV6RCG13VcyPTIHSQePycfcUv5q1Jdy28MpacL/nv1UR/o35xPBn2HkgB4OqnKtt86soCGMd9/YzQP5lY7V60kPBJbrXDApeqf+H1GALsFNQM6MCwicdE6zTqE1mzWVdhGymZR28hGJbV9H4snMDDc0tW4i3FHGrDdmb7wHM9THMx6OcCrnNyA9Sh2OyBH4MwItKfuqEg2rc56D7WAQ2JcmPQZTlBAYeFL/dYYKcXmbffEpXTbYh+7O0o9RAJ7T3uOUj/2IbSnsgg6fyw0Kotcg8iHAPvb61bZGPOEWZb your_email@charite.de```

f. Go to https://zugang.charite.de/ and log in as normal. Click on the blue button ```SSHKeys...```, paste the key from your ```.ssh/id_rsa.pub``` file, and click append.  

**3. Connect to the cluster**  
a. Type this:  
```ssh-add ~/.ssh/mdc_id_rsa``  

b. Go to the ```~/.ssh/``` folder and create a new text file. paste the below in, adding your username and leaving the '_c', and save, *without* a file extension.  
```
Host bihcluster
    ForwardAgent yes
    ForwardX11 yes
    HostName hpc-login-1.cubi.bihealth.org
    User username_c
    RequestTTY yes

Host bihcluster2
    ForwardAgent yes
    ForwardX11 yes
    HostName hpc-login-1.cubi.bihealth.org
    User username_c
    RequestTTY yes
```

c. Then, you can simply type ```ssh bihcluster```, enter the password you set during **step 2** and connect into the login node. Proceed directly to the instructions in 03_work_environment