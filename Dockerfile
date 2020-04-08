FROM jupyter/minimal-notebook:65761486d5d3

MAINTAINER Jean-Remi King <jeanremi.king@gmail.com>

# Install core debian packages
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    openssh-client \
    vim \
    curl \
    gcc \
    && apt-get clean

# Xvfb
RUN apt-get install -yq --no-install-recommends \
    xvfb \
    x11-utils \
    libx11-dev \
    qt5-default \
    && apt-get clean

ENV DISPLAY=:99

# Switch to notebook user
USER $NB_UID

# Upgrade the package managers
RUN pip install --upgrade pip
RUN npm i npm@latest -g

# Install Python packages
RUN pip install vtk && \
    pip install boto && \
    pip install h5py && \
    pip install nose && \
    pip install ipyevents && \
    pip install ipywidgets && \
    pip install mayavi && \
    pip install nibabel && \
    pip install numpy && \
    pip install pillow && \
    pip install pyqt5 && \
    pip install scikit-learn && \
    pip install scipy && \
    pip install xvfbwrapper && \
    pip install https://github.com/nipy/PySurfer/archive/master.zip && \
    pip install https://codeload.github.com/mne-tools/mne-python/zip/master

# Install Jupyter notebook extensions
RUN pip install RISE && \
    jupyter nbextension install rise --py --sys-prefix && \
    jupyter nbextension enable rise --py --sys-prefix && \
    jupyter nbextension install mayavi --py --sys-prefix && \
    jupyter nbextension enable mayavi --py --sys-prefix && \
    npm cache clean --force

# Download the MNE-sample dataset
RUN ipython -c "import mne; print(mne.datasets.sample.data_path(verbose=False))"

# Try to decrease initial IPython kernel load times
RUN ipython -c "import matplotlib.pyplot as plt; print(plt)"

# Download and move ipynb notebooks
RUN git clone --depth=1 https://github.com/mne-tools/mne-tools.github.io && \
    mv mne-tools.github.io/dev/_downloads/*/*.ipynb . && \
    rm -Rf mne-tools.github.io

# Configure the MNE raw browser window to use the full width of the notebook
RUN ipython -c "import mne; mne.set_config('MNE_BROWSE_RAW_SIZE', '9.8, 7')"

# Add an x-server to the entrypoint. This is needed by Mayavi
ENTRYPOINT ["tini", "-g", "--", "xvfb-run"]
