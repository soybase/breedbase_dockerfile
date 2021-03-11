#!/bin/bash

# create local conf file and dir for code repos
cp sgn_local.conf.template  sgn_local.conf
mkdir repos

# main code
git clone https://github.com/solgenomics/cxgn-corelibs.git repos/cxgn-corelibs
git clone https://github.com/solgenomics/sgn.git  repos/sgn
git clone https://github.com/solgenomics/Phenome.git repos/Phenome
git clone https://github.com/solgenomics/rPackages.git repos/rPackages
git clone https://github.com/solgenomics/biosource.git repos/biosource
git clone https://github.com/solgenomics/Cview.git repos/Cview
git clone https://github.com/solgenomics/ITAG.git repos/ITAG
git clone https://github.com/solgenomics/tomato_genome.git repos/tomato_genome
git clone https://github.com/solgenomics/sgn-devtools.git repos/sgn-devtools
git clone https://github.com/solgenomics/solGS.git repos/solGS
git clone https://github.com/solgenomics/starmachine.git repos/starmachine
git clone https://github.com/solgenomics/DroneImageScripts.git repos/DroneImageScripts

# Mason website skins
git clone https://github.com/solgenomics/cassava.git repos/cassava
git clone https://github.com/solgenomics/yambase.git repos/yambase
git clone https://github.com/solgenomics/sweetpotatobase.git repos/sweetpotatobase
git clone https://github.com/solgenomics/ricebase.git repos/ricebase
git clone https://github.com/solgenomics/citrusgreening.git repos/citrusgreening
git clone https://github.com/solgenomics/coconut.git repos/coconut
git clone https://github.com/solgenomics/cassbase.git repos/cassbase
git clone https://github.com/solgenomics/musabase.git repos/musabase
git clone https://github.com/solgenomics/potatobase.git repos/potatobase
git clone https://github.com/solgenomics/cea.git repos/cea
git clone https://github.com/solgenomics/cippotatobase.git repos/cippotatobase
git clone https://github.com/solgenomics/fernbase.git repos/fernbase
git clone https://github.com/solgenomics/solgenomics.git repos/solgenomics
git clone https://github.com/solgenomics/panzeabase.git repos/panzeabase
git clone https://github.com/solgenomics/varitome.git repos/varitome
git clone https://github.com/solgenomics/milkweed.git repos/milkweed
git clone https://github.com/solgenomics/erysimum.git repos/erysimum
git clone https://github.com/solgenomics/vitisbase.git repos/vitisbase
git clone https://github.com/solgenomics/panandbase.git repos/panandbase
git clone https://github.com/solgenomics/triticum.git repos/triticum
git clone https://github.com/solgenomics/gorelabbase.git repos/gorelabbbase
git clone https://github.com/solgenomics/imagesol.git repos/imagesol
