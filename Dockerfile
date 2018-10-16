#FROM cidasdpdasartip.cr.usgs.gov:8447/aqcu/rserve:latest
FROM aqcu-rserve:0.0.1

ENV REPGEN_VERSION=master
ENV GSPLOT_VERSION_DEFAULT 0.8.1

# Get GSPlot dependency installs
RUN mkdir -p /tmp/install/gsplot_description_dir && \
  wget -O /tmp/install/installPackages.R https://raw.githubusercontent.com/USGS-R/repgen/${REPGEN_VERSION}/inst/extdata/installPackages.R && \
  wget -O /tmp/install/gsplot_description_dir/DESCRIPTION https://raw.githubusercontent.com/USGS-R/gsplot/v${GSPLOT_VERSION:-$GSPLOT_VERSION_DEFAULT}/DESCRIPTION

# Install GSplot
RUN mkdir ${RSERVE_HOME}/R_libs && \
  mkdir ${RSERVE_HOME}/work && \
  cd /tmp/install/gsplot_description_dir && \
  Rscript /tmp/install/installPackages.R && \
  Rscript -e "library(devtools);install_url('https://github.com/USGS-R/gsplot/archive/v${GSPLOT_VERSION:-$GSPLOT_VERSION_DEFAULT}.zip', dependencies = F)"

# Get Repgen dependency installs
RUN mkdir -p /tmp/install/repgen_description_dir && \
  wget -O /tmp/install/repgen_description_dir/DESCRIPTION https://raw.githubusercontent.com/USGS-R/repgen/${REPGEN_VERSION}/DESCRIPTION

# Install Repgen
RUN cd /tmp/install/repgen_description_dir && \
  Rscript /tmp/install/installPackages.R && \
  Rscript -e "library(devtools);install_url('https://github.com/USGS-R/repgen/archive/${REPGEN_VERSION}.zip', dependencies = F)" && \
  rm -rf /tmp/install

