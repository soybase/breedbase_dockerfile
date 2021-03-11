FROM ubuntu:20.04

ENV CPANMIRROR=http://cpan.cpantesters.org
# based on the vagrant provision.sh script by Nick Morales <nm529@cornell.edu>

# open port 8080
#
EXPOSE 8080

# create directory layout
#
RUN mkdir -p /home/production/public/sgn_static_content
#RUN mkdir -p /home/production/tmp/solgs
#RUN mkdir -p /home/production/archive
#RUN mkdir -p /home/production/public/images/image_files
#RUN chown -R www-data /home/production/public
#RUN mkdir -p /home/production/tmp
#RUN chown -R www-data /home/production/tmp
#RUN mkdir -p /home/production/archive/breedbase
#RUN chown -R www-data /home/production/archive
#RUN mkdir -p /home/production/blast/databases/current
RUN mkdir -p /home/production/cxgn
RUN mkdir -p /home/production/cxgn/local-lib
#RUN mkdir -p /home/production/cache
#RUN chown -R www-data /home/production/cache
RUN mkdir /etc/starmachine
RUN mkdir /var/log/sgn

WORKDIR /home/production/cxgn

# install system dependencies
#
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt update -y
RUN apt install -y --no-install-recommends pkg-config apt-utils gnupg2 curl wget


RUN apt install -y --no-install-recommends libterm-readline-zoid-perl nginx starman emacs gedit vim less sudo htop git perl-doc ack-grep make xutils-dev nfs-common lynx xvfb ncbi-blast+ libmunge-dev libmunge2 munge slurm-wlm slurmctld slurmd libslurm-perl libssl-dev graphviz lsof imagemagick mrbayes muscle bowtie bowtie2 blast2 postfix mailutils libcupsimage2 postgresql-client-12 libglib2.0-dev libglib2.0-bin screen apt-transport-https libgdal-dev libproj-dev libudunits2-dev locales locales-all rsyslog cron

# Set the locale correclty to UTF-8
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN apt install -y --no-install-recommends cpanminus

# perl dependencies for sgn + chado-utils
#
RUN apt install -y --no-install-recommends \
  chado-utils \
  libalgorithm-combinatorics-perl \
  libaliased-perl \
  libapache2-mod-perl2 \
  libarchive-zip-perl \
  libarray-utils-perl \
  libbarcode-code128-perl \
  libbio-chado-schema-perl \
  libbio-db-ncbihelper-perl \
  libbio-graphics-perl \
  libbio-perl-perl \
  libcache-perl \
  libcam-pdf-perl \
  libcarp-always-perl \
  libcatalyst-action-rest-perl \
  libcatalyst-devel-perl \
  libcatalyst-perl \
  libcatalyst-plugin-authentication-perl \
  libcatalyst-plugin-authorization-roles-perl \
  libcatalyst-plugin-configloader-perl \
  libcatalyst-plugin-smarturi-perl \
  libcatalyst-view-email-perl \
  libcgi-pm-perl \
  libclass-accessor-perl \
  libclass-data-inheritable-perl \
  libclass-dbi-perl \
  libclass-load-perl \
  libclass-methodmaker-perl \
  libconfig-any-perl \
  libconfig-general-perl \
  libconfig-general-perl \
  libconfig-jfdi-perl \
  libdata-dump-perl \
  libdata-page-perl \
  libdata-uuid-perl \
  libdata-visitor-perl \
  libdatetime-perl \
  libdbi-perl \
  libdbix-class-perl \
  libdbix-connector-perl \
  libemail-sender-perl \
  libemail-simple-perl \
  libfile-flock-perl \
  libfile-nfslock-perl \
  libfile-slurp-perl \
  libgd-barcode-perl \
  libgd-graph-perl \
  libgd-text-perl \
  libhash-case-perl \
  libhtml-formfu-perl \
  libhtml-lint-perl \
  libhtml-mason-perl \
  libhtml-parser-perl \
  libhttp-message-perl \
  libhttp-message-perl \
  libimage-size-perl \
  libimage-size-perl \
  libimager-qrcode-perl \
  libimager-qrcode-perl \
  libio-string-perl \
  libio-stringy-perl \
  libipc-system-simple-perl \
  libjson-any-perl \
  libjson-perl \
  libjson-pp-perl \
  libjson-xs-perl \
  liblingua-en-inflect-perl \
  liblist-allutils-perl \
  liblist-compare-perl \
  liblist-moreutils-perl \
  libmail-sendmail-perl \
  libmath-base36-perl \
  libmath-polygon-perl \
  libmath-round-perl \
  libmodern-perl-perl \
  libmodule-build-perl \
  libmodule-find-perl \
  libmodule-pluggable-perl \
  libmoose-perl \
  libmoosex-followpbp-perl \
  libmoosex-method-signatures-perl \
  libmoosex-object-pluggable-perl \
  libmoosex-types-path-class-perl \
  libmoosex-types-uri-perl \
  libnamespace-autoclean-perl \
  libnamespace-clean-perl \
  libnumber-bytes-human-perl \
  libnumber-format-perl \
  libparallel-forkmanager-perl \
  libpath-class-perl \
  libpdf-api2-perl \
  libpdf-create-perl \
  libreadonly-perl \
  libsort-key-perl \
  libsort-versions-perl \
  libspreadsheet-parseexcel-perl \
  libspreadsheet-read-perl \
  libspreadsheet-writeexcel-perl \
  libstatistics-descriptive-perl \
  libstring-approx-perl \
  libstring-crc32-perl \
  libstring-random-perl \
  libtest-class-perl \
  libtest-exception-perl \
  libtest-mockobject-perl \
  libtest-most-perl \
  libtest-warn-perl \
  libtest-www-mechanize-perl \
  libtest-www-selenium-perl \
  libtext-csv-perl \
  libtext-unidecode-perl \
  libtry-tiny-perl \
  liburi-encode-perl \
  liburi-encode-perl \
  liburi-fromhash-perl \
  liburi-perl \
  libwww-perl \
  libxml-feed-perl \
  libxml-feed-perl \
  libxml-generator-perl \
  libxml-twig-perl \
  libyaml-perl

# various cpanm-installed module dependencies
RUN apt install -y --no-install-recommends \
  libjavascript-minifier-xs-perl \
  libpadwalker-perl \
  libtest-www-mechanize-catalyst-perl


RUN cpanm \
  Bio::GMOD::Blast::Graph@0.06 \
  Bio::GMOD::GenericGenePage@0.12 \
  Catalyst::View::Bio::SeqIO@0.02 \
  Catalyst::View::Download@0.09 \
  Catalyst::View::HTML::Mason@0.19 \
  Catalyst::View::JavaScript@0.995 \
  Digest::Crc32@0.01 \
  Email::Send::SMTP::Gmail@1.35 \
  JSAN::ServerSide@0.06 \
  Math::Round::Var@v1.0.0 \
  R::YapRI@0.05 \
  Selenium::Remote::Driver@1.39 \
  Sort::Maker@0.06 \
  Tie::Function@0.02 \
  Tie::UrlEncoder@0.02 \
  && rm -rf ~/.cpanm

# Bio::Restriction::Annotation removed in BioPerl 1.7.3; no module yet...
RUN mkdir -p /usr/local/lib/site_perl \
  && bash -o pipefail -c 'wget -O - https://github.com/bioperl/Bio-Restriction/archive/8f3286a.tar.gz \
                          | tar -C /usr/local/lib/site_perl --strip-components=2 --wildcards --files-from <(echo "*/Bio/*") -xzf -'

# additional perl dependencies for cxgn-corelibs
#
RUN apt install -y --no-install-recommends \
  libarray-compare-perl \
  libbio-featureio-perl \
  libcarp-clan-perl \
  libchart-clicker-perl \
  libclass-dbi-pager-perl  \
  libclass-dbi-pg-perl \
  libdata-bitmask-perl \
  libdbd-mysql-perl \
  libdbix-class-perl \
  libenum-perl \
  libfile-find-rule-perl \
  libgd-perl \
  libgraph-perl \
  libhash-merge-perl \
  libhtml-tree-perl \
  libhttp-server-simple-perl \
  libima-dbi-perl \
  liblog-log4perl-perl \
  libmoosex-declare-perl \
  libsoap-lite-perl \
  libtemplate-perl \
  libterm-readkey-perl \
  libtext-glob-perl \
  libthread-tie-perl \
  libxml-dom-perl \
  libxml-libxml-perl \
  libxml-simple-perl

RUN cpanm \
  Bio::Tools::Gel@1.7.3 \
  && rm -rf ~/.cpanm


# additional perl dependencies for Phenome
#
RUN apt install -y --no-install-recommends \
  libdate-calc-perl

# additional perl dependencies for biosource
#
RUN apt install -y --no-install-recommends \
  libconfig-general-perl

# additional perl dependencies for ITAG
#
RUN apt install -y --no-install-recommends \
  libcapture-tiny-perl \
  libconfig-ini-perl \
  libmock-quick-perl

RUN cpanm \
  Bio::GFF3::LowLevel@2.0 \
  Set::CrossProduct@2.006 \
  && rm -rf ~/.cpanm

# additional perl dependencies for tomato_genome
#
RUN apt install -y --no-install-recommends \
  libchart-perl \
  libdatetime-format-strptime-perl \
  libtest-output-perl \
  libfile-chdir-perl \
  libmason-perl \
  libmoosex-aliases-perl \
  libmoosex-role-parameterized-perl

# additional perl dependencies for tomato_genome
#
RUN apt install -y --no-install-recommends \
  libapp-cmd-perl \
  libbio-perl-run-perl \
  libtest-www-mechanize-catalyst-perl

# additional perl dependencies for solGS
#
RUN cpanm \
  Catalyst::View::JavaScript::Minifier::XS@2.102000 \
  Catalyst::Controller::WrapCGI@0.038 \
  && rm -rf ~/.cpanm


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

# 2021-03-09 package snapshot
# https://docs.rstudio.com/rspm/admin/serving-binaries/#binaries-r-configuration-linux
RUN echo 'options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/__linux__/focal/1790917"))' > $(R RHOME)/etc/Rprofile.site \
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

# https://github.com/rocker-org/rocker-versioned/issues/242
ENV TZ=UTC
RUN installGithub.r \
  onaio/ona.R@v0.1 \
  reyzaguirre/st4gi

# MooseX::Runnable Perl module needs this:
#
RUN apt-get install libmoosex-runnable-perl -y

RUN apt-get install libgdm-dev -y
RUN apt-get install npm -y

WORKDIR /home/production/cxgn/sgn

ENV PERL5LIB=/home/production/cxgn/local-lib/:/home/production/cxgn/local-lib/lib/perl5:/home/production/cxgn/sgn/lib:/home/production/cxgn/cxgn-corelibs/lib:/home/production/cxgn/Phenome/lib:/home/production/cxgn/Cview/lib:/home/production/cxgn/ITAG/lib:/home/production/cxgn/biosource/lib:/home/production/cxgn/tomato_genome/lib:.

# run the Build.PL to install the R dependencies...
#
ENV HOME=/home/production
ENV PGPASSFILE=/home/production/.pgpass
#RUN rm /home/production/cxgn/sgn/static/static
#RUN rm /home/production/cxgn/sgn/static/s
#RUN rm /home/production/cxgn/sgn/documents

#INSTALL OPENCV IMAGING LIBRARY
RUN apt-get install -y python3-dev python3-pip python-numpy libgtk2.0-dev libgtk-3-0 libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libhdf5-serial-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libxvidcore-dev libatlas-base-dev gfortran libgdal-dev exiftool libzbar-dev cmake
RUN pip3 install --no-cache-dir imutils numpy matplotlib pillow statistics PyExifTool pytz pysolar scikit-image packaging pyzbar pandas opencv-python \
    && pip3 install -U keras-tuner

# legacy blast interface for several sgn modules that use Bio::BLAST::Database
# https://github.com/solgenomics/sgn/issues/3383
RUN apt install -y --no-install-recommends ncbi-blast+-legacy \
  && cpanm -f Bio::BLAST::Database@0.4 \
  && rm -rf ~/.cpanm

# deprecated String::CRC used by several sgn modules; consider replacing with String::CRC32
RUN cpanm \
  String::CRC@1.0 \
  && rm -rf ~/.cpanm

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

COPY sgn_local.conf.template /home/production/cxgn/sgn/sgn_local.conf
COPY starmachine.conf /etc/starmachine/
COPY slurm.conf /etc/slurm-llnl/slurm.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN ln -s /home/production/cxgn/starmachine/bin/starmachine_init.d /etc/init.d/sgn

ARG CREATED
ARG REVISION
ARG BUILD_VERSION

LABEL maintainer="lam87@cornell.edu"
LABEL org.opencontainers.image.created=$CREATED
LABEL org.opencontainers.image.url="https://breedbase.org/"
LABEL org.opencontainers.image.source="https://github.com/solgenomics/breedbase_dockerfile"
LABEL org.opencontainers.image.version=$BUILD_VERSION
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.vendor="Boyce Thompson Institute"
LABEL org.opencontainers.image.title="breedbase/breedbase"
LABEL org.opencontainers.image.description="Breedbase web server"
LABEL org.opencontainers.image.documentation="https://solgenomics.github.io/sgn/"

# start services when running container...
ENTRYPOINT /bin/bash /entrypoint.sh
