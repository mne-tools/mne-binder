# Binder Docker config file.

# This is required
FROM andrewosh/binder-base
MAINTAINER Jean-Remi King <jeanremi.king@gmail.com>

# Install dependencies and MNE master
RUN conda update conda; conda install --yes --quiet numpy setuptools numpy scipy matplotlib scikit-learn nose h5py PIL pyside; pip install -q nibabel boto https://github.com/mne-tools/mne-python/archive/master.zip

# Download data
RUN ipython -c "import mne; print(mne.datasets.sample.data_path(verbose=False))"

# Try to decrease initial IPython kernel load times?
RUN ipython -c "import matplotlib.pyplot as plt; print(plt)"

# Download and move ipynb notebooks
RUN git clone --depth=1 https://github.com/mne-tools/mne-tools.github.io; mv mne-tools.github.io/dev/_downloads/*.ipynb .; rm -Rf mne-tools.github.io
