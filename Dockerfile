FROM ubuntu:20.04

LABEL maintainer="lam87@cornell.edu"

ENV CPANMIRROR=http://cpan.cpantesters.org
# based on the vagrant provision.sh script by Nick Morales <nm529@cornell.edu>

# open port 8080
#
EXPOSE 8080

# create directory layout
#
RUN mkdir -p /home/production/public/sgn_static_content
RUN mkdir -p /home/production/tmp/solgs
RUN mkdir -p /home/production/archive
RUN mkdir -p /home/production/public/images/image_files
RUN chown -R www-data /home/production/public
RUN mkdir -p /home/production/tmp
RUN chown -R www-data /home/production/tmp
RUN mkdir -p /home/production/archive/breedbase
RUN chown -R www-data /home/production/archive
RUN mkdir -p /home/production/blast/databases/current
RUN mkdir -p /home/production/cxgn
RUN mkdir -p /home/production/cxgn/local-lib
RUN mkdir -p /home/production/cache
RUN chown -R www-data /home/production/cache
RUN mkdir /etc/starmachine
RUN mkdir /var/log/sgn

WORKDIR /home/production/cxgn

# install system dependencies
#
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt update
RUN apt upgrade -y
RUN apt install -y build-essential pkg-config apt-utils gnupg2 curl wget

#RUN apt-get update --fix-missing -y

RUN apt install -y libterm-readline-zoid-perl nginx starman emacs gedit vim less sudo htop git perl-doc ack-grep make xutils-dev nfs-common lynx xvfb ncbi-blast+ libmunge-dev libmunge2 munge slurm-wlm slurmctld slurmd libslurm-perl libssl-dev graphviz lsof imagemagick mrbayes muscle bowtie bowtie2 blast2 postfix mailutils libcupsimage2 postgresql-client-12 libglib2.0-dev libglib2.0-bin screen apt-transport-https libgdal-dev libproj-dev libudunits2-dev locales locales-all rsyslog cron

# Set the locale correclty to UTF-8
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus



RUN chmod 777 /var/spool/ \
    && mkdir /var/spool/slurmstate \
    && chown slurm:slurm /var/spool/slurmstate/ \
    && /usr/sbin/create-munge-key \
    && ln -s /var/lib/slurm-llnl /var/lib/slurm

# required Ubuntu package dependencies for R packages (per https://packagemanager.rstudio.com/)
# + OpenBLAS for performance & littler for concise install commands
#
RUN apt install -y --no-install-recommends \
  imagemagick \
  libcairo2-dev \
  libcurl4-openssl-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libicu-dev \
  libjpeg-dev \
  libmagick++-dev \
  libopenblas-base \
  libpng-dev \
  libssl-dev \
  libxml2-dev \
  littler \
  make \
  pandoc \
  r-base \
  r-base-dev \
  zlib1g-dev

# 2021-02-18 package snapshot
# https://docs.rstudio.com/rspm/admin/serving-binaries/#binaries-r-configuration-linux
RUN echo 'options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/__linux__/focal/1444919"))' > $(R RHOME)/etc/Rprofile.site \
  && echo 'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> $(R RHOME)/etc/Rprofile.site

# littler setup
RUN Rscript -e 'install.packages("docopt")' \
  && ln -s $(R RHOME)/site-library/littler/examples/install2.r \
           $(R RHOME)/site-library/littler/examples/installGithub.r /usr/local/bin/

# R dependencies for repos/sgn
#
RUN install2.r --error --skipinstalled \
  DT \
  RCurl \
  agricolae \
  catchr \
  data.table \
  devtools \
  dplyr \
  effects \
  emmeans \
  gge \
  ggplot2 \
  gmailr \
  grid \
  gridExtra \
  hrbrthemes \
  httr \
  jsonlite \
  knitr \
  leaflet \
  lme4 \
  lmerTest \
  ltm \
  lubridate \
  magrittr \
  methods \
  na.tools \
  readr \
  rjson \
  rrBLUP \
  shiny \
  shinyjs \
  shinythemes \
  stringr \
  tidyr \
  tidyverse \
  viridis \
  waves

RUN installGithub.r \
  onaio/ona.R \
  reyzaguirre/st4gi

# copy some tools that don't have a Debian package
#
COPY tools/gcta/gcta64  /usr/local/bin/
COPY tools/quicktree /usr/local/bin/
COPY tools/sreformat /usr/local/bin/

# copy code repos. Run the prepare.pl script to clone them
# before the build
# This also adds the Mason website skins
#
ADD repos /home/production/cxgn

COPY slurm.conf /etc/slurm-llnl/slurm.conf

COPY sgn_local.conf.template /home/production/cxgn/sgn/
COPY starmachine.conf /etc/starmachine/
COPY slurm.conf /etc/slurm-llnl/slurm.conf

# XML::Simple dependency
#
RUN apt-get install libexpat1-dev -y

# HTML::FormFu
#
RUN apt-get install libcatalyst-controller-html-formfu-perl -y

# Cairo Perl module needs this:
#
RUN apt-get install libcairo2-dev -y

# GD Perl module needs this:
#
RUN apt-get install libgd-dev -y

# postgres driver DBD::Pg needs this:
#
RUN apt-get install libpq-dev -y

# MooseX::Runnable Perl module needs this:
#
RUN apt-get install libmoosex-runnable-perl -y

RUN apt-get install libgdm-dev -y
RUN apt-get install nodejs -y

WORKDIR /home/production/cxgn/sgn

ENV PERL5LIB=/home/production/cxgn/local-lib/:/home/production/cxgn/local-lib/lib/perl5:/home/production/cxgn/sgn/lib:/home/production/cxgn/cxgn-corelibs/lib:/home/production/cxgn/Phenome/lib:/home/production/cxgn/Cview/lib:/home/production/cxgn/ITAG/lib:/home/production/cxgn/biosource/lib:/home/production/cxgn/tomato_genome/lib:/home/production/cxgn/Chado/chado/lib:/home/production/cxgn/Bio-Chado-Schema/lib:.

# run the Build.PL to install the R dependencies...
#
ENV HOME=/home/production
ENV PGPASSFILE=/home/production/.pgpass
#RUN rm /home/production/cxgn/sgn/static/static
#RUN rm /home/production/cxgn/sgn/static/s
#RUN rm /home/production/cxgn/sgn/documents

#INSTALL OPENCV IMAGING LIBRARY
RUN apt-get install -y python3-dev python-pip python3-pip python-numpy libgtk2.0-dev libgtk-3-0 libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libhdf5-serial-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libxvidcore-dev libatlas-base-dev gfortran libgdal-dev exiftool libzbar-dev cmake

RUN pip3 install imutils numpy matplotlib pillow statistics PyExifTool pytz pysolar scikit-image packaging pyzbar pandas \
    && pip3 install -U keras-tuner \
    && cd /home/production/cxgn/opencv \
    && mkdir build \
    && cd /home/production/cxgn/opencv/build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=/home/production/cxgn/opencv_contrib/modules \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
        -D BUILD_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_GENERATE_PKGCONFIG=YES .. \
    && make \
    && make install \
    && ldconfig
RUN mv /usr/local/lib/python3.5/dist-packages/cv2/python-3.5/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python3.5/dist-packages/cv2/python-3.5/cv2.so

RUN g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_multi.cpp -o /usr/bin/stitching_multi `pkg-config opencv4 --cflags --libs` \
    && g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_single.cpp -o /usr/bin/stitching_single `pkg-config opencv4 --cflags --libs`

RUN bash /home/production/cxgn/sgn/js/install_node.sh

COPY entrypoint.sh /entrypoint.sh
RUN ln -s /home/production/cxgn/starmachine/bin/starmachine_init.d /etc/init.d/sgn

# start services when running container...
ENTRYPOINT /bin/bash /entrypoint.sh
