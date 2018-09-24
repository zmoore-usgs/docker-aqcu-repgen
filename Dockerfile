FROM cidasdpdasartip.cr.usgs.gov:8447/aqcu/rserve:latest

ENV REPGEN_VERSION=v1.11.3

# Get Repgen dependency installs
RUN mkdir -p /tmp/install/repgen_description_dir && \
  wget -O /tmp/install/repgen_description_dir/DESCRIPTION https://raw.githubusercontent.com/USGS-R/repgen/${REPGEN_VERSION}/DESCRIPTION && \
  wget -O /tmp/install/installPackages.R https://raw.githubusercontent.com/USGS-R/repgen/${REPGEN_VERSION}/inst/extdata/installPackages.R

# Install Repgen
RUN cd /tmp/install/repgen_description_dir && \
  Rscript /tmp/install/installPackages.R && \
  Rscript -e "library(devtools);install_url('https://github.com/USGS-R/repgen/archive/${REPGEN_VERSION}.zip', dependencies = F)" && \
  rm -rf /tmp/install

