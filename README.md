# BIH-CUBI HPC Guide

The Romagnani lab uses the [Berlin Institute of Health-Core Bioinformatics Unit (BIH-CUBI) High Performance Computing (HPC) cluster](https://www.hpc.bihealth.org/) for computational work.

For RStudio and JupterLab, go to the >> **[BIH Dashboard](https://hpc-portal.cubi.bihealth.org/pun/sys/dashboard/)** <<

If you run into trouble using any part of the HPC, heres an order of where to look for guidance:  
1. The BIH-CUBI HPC [documents](https://bihealth.github.io/bih-cluster/)
2. The BIH-CUBI HPC [question board](https://hpc-talk.cubi.bihealth.org/) for posting and helping with issues  
3. Ollie  
4. The HPC helpdesk (hpc-helpdesk@bih-charite.de), explaining your problem according to [these guidelines](https://bihealth.github.io/bih-cluster/help/good-tickets/)  

# Contents

**[VPN access and requesting an account]()**  
**[Connecting to the cluster]()**  
**[Setting up your work environment]()**  
**[Setting up an RStudio session]()**  


# VPN access and requesting an account

1. **Fill in both VPN forms, [`vpn_antrag.pdf`](https://github.com/romagnanilab/bih-cubi/blob/main/files/vpn_antrag.pdf), and [`vpn_zusatzantrag_b.pdf`](https://github.com/romagnanilab/bih-cubi/blob/main/files/vpn_zusatzantrag_b.pdf)**  
Print and sign both, then scan and send both files to to *vpn@charite.de*, cc'ing Chiara (*chiara.romagnani@charite.de*).

2. **For personal computer access, install OpenVPN and configure your connection**  
Refer to either installation on macOS ([`vpn_macOS_installation.pdf`](https://github.com/romagnanilab/bih-cubi/blob/main/files/vpn_macOS_install.pdf)) or Windows ([`vpn_Windows_installation.pdf`](https://github.com/romagnanilab/bih-cubi/blob/main/files/vpn_Windows_install.pdf)) if you run into trouble.

If you have any issues, feel free to ask Ollie (*oliver.knight@charite.de*) for help. You can also check out the BIH-CUBI cluster guide [here](https://bihealth.github.io/bih-cluster/).

3. **Applying for an HPC user account**  

Please fill in the form below and forwarded to Ollie, who is the named delegate for AG Romagnani with the cluster.

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
- BIH/Charite/MDC user name:
- duration of cluster access (max 1 year): 1 year
- AG: ag-romagnani
```

Ollie will then forward this to the CUBI team who will set up your account.

# Connecting to the cluster

**1. Login to the CUBI dashboard through your browser**   

Go [here](https://hpc-portal.cubi.bihealth.org/pun/sys/dashboard/) here to log in to access the Dashboard.  
***a. DRFZ computer Windows login***  
Login with your username in this format: `username@CHARITE`  

***b. Work Mac or personal computer/laptop***  
Login with your Charite credentials, i.e. `username`

<details>
  <summary>Optional - terminal connection</summary>
    
**2. Creating a secure shell (ssh) key**  

a. In terminal, type `ssh-keygen -t rsa -C "your_email@charite.de"` # leaving the quotation marks, enter your e-mail.  

c. Use the default location for storing your ssh key (press enter), and type a secure password in to store it.  

d. Locate the `.ssh/id_rsa.pub` file in your file explorer and open with notepad/textedit. You may need to enable the 'show hidden files and folders' setting in your control panel.  

e. Copy the contents; it should look something like  
```
ssh-rsa AAAAAB3NzaC1yc2EAAAADAQABAAABAQC/Rdd5rf4BT38jsBrXpd1vjE1iZZlEmkB6809QK7hV6RCG13VcyPTIHSQePycfcUv5q1Jdy28MpacL/nv1UR/o35xPBn2HkgB4OqnKtt86soCGMd9/YzQP5lY7V60kPBJbrXDApeqf+H1GALsFNQM6MCwicdE6zTqE1mzWVdhGymZR28hGJbVsnMDDc0tW4i3FHGrDdmb7wHM9THMx6OcCrnNyA9Sh2OyBH4MwItKfuqEg2rc56D7WAQ2JcmPQZTlBAYeFL/dYYKcXmbffEpXTbYh+7O0o9RAJ7T3uOUj/2IbSnsgg6fyw0Kotcg8iHAPvb61bZGPOEWZb your_email@charite.de
```

f. Go to https://zugang.charite.de/ and log in as normal. Click on the blue button `SSHKeys...`, paste the key from your `.ssh/id_rsa.pub` file, and click append.  

**4. Connect to the cluster**  
a. Type `ssh-add`  

b. Go to the `$HOME/.ssh/` folder and create a new text file. paste the below in, adding your username and leaving the '_c', and save, *without* a file extension.  
```bash
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

c. Then, you can simply type `ssh bihcluster``  
Enter the password you set during **step 2** and connect into the login node. Proceed directly to the instructions in [03_work_environment](https://github.com/romagnanilab/bih-cubi/tree/main/03_work_environment)

</details>

# Setting up your work environment

Upon connecting using the `ssh bihcluster` command, or through `Clusters -> _cubi Shell Access` on the Dashboard, you'll find yourself in a login node.   
**Do not** run anything here as there is limited RAM and CPU for anything, it is only intended for running `tmux` sessions.  

**1. Creating an interactive session** 

`tmux` is essentially a new window for your command line. You can attach and detach these and they will run in the background even when you close your terminal window.  

To begin:
```bash
tmux new -s cubi # create a new tmux session with the name 'cubi'
```

You can detach this at any time by pressing CTRL+b, letting go, and pressing the d key. You can reattach at any time in 'base' command windows by typing `tmux a -t cubi`, or simply `tmux a` to attach your last accessed session. `tmux ls` lists your sessions.  

Next, we will ask the workload managing system `slurm` to allocate us some cores and RAM.

```bash
srun --time 24:00:00 --ntasks 16 --mem 32G --immediate=1200 --pty bash -i
```  

This creates a session which will last 24h, allow you to use 16 CPU cores, and 32Gb RAM. From here, we can install software, packages, extract files and run programs.

**2. Setting up a workspace environment**

From here, how you set up your workspace is entirely your decision. However the file structure of the BIH-CUBI cluster is set up like this:

- Your home directory, `$HOME/`, or also sometimes written `/fast/users/$USER`, is only 1Gb in space and should not contain anything other than *links* to other folders; already set up are `/fast/scratch/users/${USER}` and `/fast/work/users/${USER}`. You can always check wherever you are with `pwd`.  
- Your `$HOME/scratch` folder has a quota of 200 Tb; however, files are deleted after 2 weeks from the time of their creation. This will be where large data such as sequencing runs and processing pipelines are run.
- Your `$HOME/work` folder has a hard quota of 1 Tb and is for non-group personal use.
- Finally, there is the `/fast/groups/ag_romagnani/` folder, where communal programs, scripts and reference genomes/files are kept.  

You can at any time check your quota with the command `bih-gpfs-quota-user $USER`

Below is a set of instructions to install miniconda3, which is required to install Seurat and other R packages.

```bash

mv ${HOME}/.config work/bin/ && ln -s $HOME/work/bin/.config .config
mv ${HOME}/.cache work/bin/ && ln -s $HOME/work/bin/.cache .cache
mv ${HOME}/.local work/bin/ && ln -s $HOME/work/bin/.local .local
mv ${HOME}/ondemand work/bin/ && ln -s $HOME/work/bin/ondemand ondemand

# link the group folder, and set up your work/bin/ folder
ln -s /fast/work/groups/ag_romagnani/ group
mkdir $HOME/work/bin/ && cd $HOME/work/bin/

# download, install, and update miniconda 
curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/work/bin/miniconda3 && rm Miniconda3-latest-Linux-x86_64.sh
source ${HOME}/work/bin/miniconda3/etc/profile.d/conda.sh && conda activate

# modify conda repositories  
nano $HOME/.condarc

# copy and paste this into nano (CTRL+C here, right click to paste)
channels:
  - conda-forge
  - bioconda
  - bih-cubi
  - defaults
show_channel_urls: true
changeps1: true
channel_priority: flexible
# close by CTRL+X and y and enter

conda upgrade --all -y
conda config --set solver libmamba

# If you'd like to make a conda env now for single cell analysis in R, run these steps:  
conda create -y -n R_4.3.2 r-base==4.3.2 r-tidyverse r-biocmanager r-hdf5r r-devtools r-r.utils r-seurat r-signac r-leiden r-matrix r-pals r-ggsci r-ggthemes r-showtext r-ggtext r-ggpubr r-ggridges r-ggtext r-ggh4x openssl==3.1.3
conda activate R_4.3.2
conda install r-base=4.3.2 bioconductor-motifmatchr bioconductor-tfbstools bioconductor-chromvar bioconductor-bsgenome.hsapiens.ucsc.hg38 bioconductor-ensdb.hsapiens.v86 bioconductor-deseq2 bioconductor-limma r-harmony bioconductor-biocfilecache openssl==3.1.3

conda create -y -n r-reticulate -c vtraag python-igraph pandas umap-learn scanpy macs2 scvi-tools graph-tool

```

In the above script, we make a folder called `bin` in your work directory, and then download and install miniconda. We then use it to create our R environment named `R_4.3.2`, but you can name this whatever you want.

If at any point you come into errors installing packages through RStudio directly, try using this format while in the `R_4.3.2` conda environment: `conda install r-package`, replacing the word 'package' with what you want to install. The 'r-' prefix indicates it's an `R` package, and not a `python` one.

# Setting up an RStudio session
In terminal, perform:  
```bash
mkdir -p $HOME/work/bin/ondemand/dev && cd $HOME/work/bin/ondemand/dev
git clone https://github.com/bihealth/ood-bih-rstudio-server.git
nano $HOME/work/bin/ondemand/dev/ood-bih-rstudio-server/template/script.sh.erb

# under export LD_LIBRARY_PATH=/usr/lib64/:\$LD_LIBRARY_PATH, add:
export LD_PRELOAD=/fast/work/users/$USER/bin/miniconda3/envs/R_4.3.2/lib/libstdc++.so.6 
# save and close with CTRL + X, Y and enter
```

**1. Navigate to [this page](https://hpc-portal.cubi.bihealth.org/pun/sys/dashboard/).** You must be connected to the Charite VPN to access this page

**2. In the top bar, go to `Interactive Apps` then the red `RStudio Server (Sandbox)`** button. It's important you choose the *Sandbox* RStudio server due to some ongoing package loading issues with the OnDemand platform

From here, you can customise the session you want:

```bash
**R source:** change to miniconda  
**Miniconda path:** $HOME/bin/miniconda3/bin:R_4.3.2 # or whatever you named the environment to be
**Singularity image:** *leave as is*  
**Number of cores:** Maximum 32
**Memory [GiB]:** Maximum 128  
**Running time [days]:** Maximum 14, recommended 1  
**Partition to run in:** medium
```

When you launch this, it will queue the request as it goes through the `slurm` workload manager. It will then automatically update when it is running, and you can launch the session. If it is taking too long, reduce the cores, memory, and running time. 16 cores, 64 Gb RAM, and 1 day often works well.

**5.** Finallising our R environment, we move back to ondemand, launch a session once more, and perform these steps:

At the beginning of your script, you must let R know where your python environment is to use reticulate:

```R
Sys.setenv(PATH = paste('~/work/bin/miniconda3/envs/r-reticulate/lib/python3.10/site-packages/', Sys.getenv()['PATH'], sep = ':'))
library(reticulate)
assignInNamespace("is_conda_python", function(x){ return(FALSE) }, ns="reticulate")
use_miniconda('~/work/bin/miniconda3/envs/r-reticulate/', required = T)
```

Then:

```R
update.packages(ask = FALSE, checkBuilt = TRUE)
remotes::install_github(c('satijalab/azimuth', 'satijalab/seurat-data', 'chris-mcginnis-ucsf/DoubletFinder', 'carmonalab/UCell', 'satijalab/seurat-wrappers', 'mojaveazure/seurat-disk'), force = T)
```

In July and August 2024, AG Romagnani was migrated from gpfs-1 to cephfs-1/-2. These steps were used during this process:

<details open>
<summary>Preparing for BIH-CUBI drive migration</summary>
<br>
### 1. First, we log into OnDemand and open the terminal by going to the top bar:
 Clusters -> >_ cubi Shell Access

### 2. Then, we open a terminal multiplex session and begin an interactive session
`tmux new -s environment_export`  
`srun --time 24:00:00 --ntasks 16 --mem 16G --immediate=10000 --pty bash -i`

### 3. Finally, we begin the export of the miniconda3 environments
`source ~/work/bin/miniconda3/etc/profile.d/conda.sh`  
`bash ~/group/work/bin/miniconda_envs/export_envs.sh`

### 4. Once this is finished, run the following lines
`conda clean --all -y`  
`pip cache purge`

### 5. Removing large files from user spaces to improve drive performance
Only run these if you are sure you know what you're deleting - ask Ollie for guidance  
`find ~/work/data -name '.bam*' -delete`  
`find ~/work/data -name '.cloupe*' -delete`  
`find ~/work/data -name '*molecule_info*' -delete`  

### 6. Exit interactive session
Now, type and enter `exit` until you leave the interactive session.
You can also check other active sessions with `tmux ls`, and attach these with `tmux a -t session`, and `exit` these, too.
</details>

<details open>
<summary>Following migration to cephfs-1/-2</summary>
<br>
<p align="center" style="font-size: 1.5em;">
  <span style="color: red;">🔴</span> <strong>Note: if you come across any errors while performing this, please check with Ollie, or you risk losing data!🔴</strong>
</p>

### 1. First, we log into OnDemand and open the terminal by going to the top bar:
 Clusters -> >_ cubi Shell Access

### 2. Then, we open a terminal multiplex session and begin an interactive session
`tmux new -s environment_export`  
`srun --time 48:00:00 --ntasks 16 --mem 16G --immediate=10000 --pty bash -i`

### 3. Firstly, we are going to move all data from the old drive (gpfs-1) to the new drive (cephfs-1)
```bash
SOURCE=/data/gpfs-1/work/users/${USER}/work/
TARGET=/data/cephfs-1/home/users/${USER}/work/
rsync -ahP --stats $SOURCE $TARGET
```
Note that this will take a long time. Furthermore, it will move your *old* miniconda installation, so you will want to either **delete** this or move it with `mv miniconda3 temp` so that it does not get in the way of the re-installation.

Please also check if all of the files were moved:
```bash
find $SOURCE -type f | wc -l
```
This should output `0`. If not, check what hasn't moved by looking at `ls $SOURCE`.  

Please check through all of your folders in your *new* work folder with `ls` to list files, `cd $folder` (where folder is the folder you want to enter) and `cd ..` to move up one level.

### 4. Secondly, we're going to re-install miniconda and re-create all of the shortcuts
`bash /data/cephfs-2/unmirrored/groups/romagnani/work/bin/first_time_setup.sh`

Here, you can either create the default `R_4.3.3` and `r-reticulate` environments from nothing using the pre-created ones, or recreate your old ones *if you exported them*

```bash
source ~/work/bin/miniconda3/etc/profile.d/conda.sh

for env in ~/group/work/bin/miniconda_envs/${USER}/*; do
    env=$(basename ${env} .yml)
    echo "Re-creating the ${env} environment"
    echo ""
    conda env create -f ~/group/work/bin/miniconda_envs/${USER}/${env}.yml
    echo ""
done
```

### 6. Exit interactive session
Now, type and enter `exit` until you leave the interactive session.
You can also check other active sessions with `tmux ls`, and attach these with `tmux a -t session`, and `exit` these, too.
</details>
