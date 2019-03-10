FROM andrewosh/binder-base
MAINTAINER Jean-Remi King <jeanremi.king@gmail.com>

# Install dependencies and MNE master
RUN conda update conda; 
RUN conda install --yes --quiet numpy scipy matplotlib
RUN pip install mne

# Download data
RUN ipython -c "import mne; print(mne.datasets.sample.data_path(verbose=True))"
