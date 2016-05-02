# Binder Docker config file.

FROM kingjr/mne-binder

MAINTAINER Jean-Remi King <jeanremi.king@gmail.com>

USER main

# Install dependencies
RUN conda install numpy setuptools numpy scipy matplotlib scikit-learn nose mayavi pandas h5py PIL patsy pyside
RUN pip install nibabel

# Install stable MNE
RUN pip install mne

# Download datasets
RUN python -c "import mne; mne.datasets.sample.data_path()"

# Download ipynb notebooks
RUN git clone https://github.com/mne-tools/mne-tools.github.io

# Dynamic copy of the notebooks into 'notebooks' directory at jupyter startup
RUN sed '$icp $HOME/mne-tools.github.io/stable/_downloads/*.ipynb $HOME/notebooks/' $HOME/start-notebook.sh --in-place
