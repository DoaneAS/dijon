#!/bin/bash

locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
export LANGUAGE="en_US.UTF-8"
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
mkdir /share /local-scratch /Software /scratch
mkdir /scratchLocal
mkdir /pbtech_mounts
mkdir /pbtech_mounts/softlib001
mkdir /pbtech_mounts/oelab_store003
mkdir /athena
mkdir /cluster001
mkdir -p /scratch/data
mkdir -p /scratch/logs
chmod -R 777 /scratch
chmod 777 /tmp
chmod +t /tmp
chmod 777 /Software
apt-get update
apt-get install -y apt-transport-https build-essential cmake curl libsm6 libxrender1 libfontconfig1 wget vim git unzip python-setuptools ruby bc
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
echo "deb https://cloud.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
apt-get update
apt-get install -y r-base-dev gdebi-core
apt-get install -y time
# Install R, Python, misc. utilities
apt-get install -y libopenblas-dev r-base-core libcurl4-openssl-dev libopenmpi-dev openmpi-bin openmpi-common openmpi-doc openssh-client openssh-server libssh-dev libcairo2-dev wget vim git libssl-dev libcurl4-openssl-dev nano git cmake  gfortran g++ curl wget python autoconf bzip2 libtool libtool-bin python-pip python-dev
#apt-get clean
#locale-gen en_US.UTF-8

#apt-get install -y  software-properties-common
#add-apt-repository ppa:webupd8team/java -y
#apt-get update
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
#apt-get install -y oracle-java8-installer
#apt install oracle-java8-set-default
apt-get clean

# Install homebrew science, can't use root
useradd -m singularity
cd /Software
su -c 'git clone https://github.com/Linuxbrew/brew.git' singularity
su -c '/Software/brew/bin/brew install bsdmainutils parallel util-linux' singularity
su -c '/Software/brew/bin/brew tap homebrew/science' singularity
su -c '/Software/brew/bin/brew install art bwa samtools' singularity
su -c 'rm -r $(/Software/brew/bin/brew --cache)' singularity
su -c 'wget http://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh' singularity

bash Anaconda2-4.3.1-Linux-x86_64.sh -b -p /Software/anaconda3
rm Anaconda2-4.3.1-Linux-x86_64.sh
/Software/anaconda2/bin/conda update -y conda
/Software/anaconda2/bin/conda update -y anaconda
/Software/anaconda2/bin/conda config --add channels conda-forge
/Software/anaconda2/bin/conda config --add channels defaults
/Software/anaconda2/bin/conda config --add channels r
/Software/anaconda2/bin/conda config --add channels bioconda
/Software/anaconda2/bin/conda install -y --channel bioconda kallisto
/Software/anaconda2/bin/conda install -y macs2
/Software/anaconda2/bin/conda install -y deeptools
/Software/anaconda2/bin/conda clean -y --all
wget --no-check-certificate https://github.com/RealTimeGenomics/rtg-core/releases/download/3.6.2/rtg-core-non-commercial-3.6.2-linux-x64.zip
unzip rtg-core-non-commercial-3.6.2-linux-x64.zip
echo "n" | /Software/rtg-core-non-commercial-3.6.2/rtg --version

  # Install required R packages
R --slave -e 'install.packages("devtools", repos="https://cloud.r-project.org/")'
R --slave -e 'devtools::install_github("rstudio/tensorflow")'
R --slave -e 'source("https://bioconductor.org/biocLite.R"); biocLite(); biocLite("BSgenome.Hsapiens.UCSC.hg19"); biocLite("BSgenome.Mmusculus.UCSC.mm9"); biocLite("BSgenome.Hsapiens.UCSC.hg19"); biocLite("BSgenome.Hsapiens.UCSC.hg38")'
R --slave -e 'devtools::install_github("GreenleafLab/chromVAR")'
R --slave -e 'install.packages("Cairo", repos="https://cloud.r-project.org/")'
R --slave -e 'install.packages(c("hash", "digest", "data.table"))'
# install java 8
#apt-get install -y  software-properties-common && \
#add-apt-repository ppa:webupd8team/java -y && \
#apt-get update && \
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
#apt-get install -y oracle-java8-installer && \
#apt-get clean

#install picard

#git clone git@github.com:broadinstitute/picard.git
#cd picard/
# ./gradlew shadowJar

#
cd /Software
#git clone https://github.com/slowkow/picardmetrics
#cd picardmetrics
# Download and install the dependencies.
#make get-deps
# Install picardmetrics and the man page.
#make install

sed -i 's|PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin|PATH="/Software/rtg-core-non-commercial-3.6.2:/Software/brew/bin:/Software/anaconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"|' /environment

/Software/anaconda3/bin/conda list | tail -n+3 | awk '{print $1, $2, "Anaconda"}' > /Software/.info
find /Software/brew/Cellar -maxdepth 2 -print | sed 's|/Software/brew/Cellar||g' | sed 's|^/||' | grep "/" | sed 's|/|\t|' | sort | awk '{print $1, $2, "Homebrew"}'>> /Software/.info
/Software/rtg-core-non-commercial-3.6.2/rtg version | head -1 | awk '{print $2, $5, "User_Install"}' >> /Software/.info
