FROM rocker/rstudio:3.6.2

ENV REPRO_NAME all-harvest-repro

ENV REPRO_USER repro
ENV REPRO_UID 1000
ENV REPRO_GID 1000

RUN echo '***** Update OS packages needed to build and use this image*****' \
    && apt -y update                                                        \
    && apt -y install apt-utils wget curl makepasswd make git               \
    && apt -y install sudo man less file tree procps

RUN echo '***** Install R packages needed to run the analysis *****'        \
    && R -e "install.packages(c('dplyr', 'ggplot2', 'RColorBrewer'))"       \
    && R -e "install.packages(c('tidyr', 'jsonlite', 'base64enc'))"         \
    && R -e "install.packages(c('htmltools', 'knitr', 'rmarkdown'))"

RUN echo '***** Replace the rstudio user with the repro user *****'         \
    && userdel rstudio                                                      \
    && groupadd ${REPRO_USER} --gid ${REPRO_GID}                            \
    && useradd ${REPRO_USER} --uid ${REPRO_UID} --gid ${REPRO_GID}          \
        --shell /bin/bash                                                   \
        --create-home                                                       \
        -p `echo repro | makepasswd --crypt-md5 --clearfrom - | cut -b8-`   \
    && echo "${REPRO_USER} ALL=(ALL) NOPASSWD: ALL"                         \
            > /etc/sudoers.d/${REPRO_USER}                                  \
    && chmod 0440 /etc/sudoers.d/repro

ENV HOME /home/${REPRO_USER}
USER  ${REPRO_USER}
WORKDIR $HOME

ENV REPRO_MNT /mnt/${REPRO_NAME}

COPY --chown=1000:1000 ./.docker/.rstudio ${HOME}/.rstudio

RUN echo "export IN_RUNNING_REPRO=${REPRO_NAME}" >> .bashrc
RUN echo "cd ${REPRO_MNT}" >> .bashrc

RUN echo "setwd('${REPRO_MNT}/analysis')" >> .Rprofile

CMD  /bin/bash -il
