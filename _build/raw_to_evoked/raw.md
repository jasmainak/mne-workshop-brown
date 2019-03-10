---
redirect_from:
  - "/raw-to-evoked/raw"
interact_link: content/raw_to_evoked/raw.ipynb
kernel_name: python3
title: 'Raw data'
prev_page:
  url: /raw_to_evoked/intro
  title: 'Raw to evoked'
next_page:
  url: /raw_to_evoked/epochs
  title: 'Epochs'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---



{:.input_area}
```python
%matplotlib inline
```




The [Raw](https://martinos.org/mne/stable/generated/mne.io.Raw.html) data structure: continuous data
=============================================================

Continuous data is stored in objects of type [Raw](https://martinos.org/mne/stable/generated/mne.io.Raw.html).
The core data structure is simply a 2D numpy array (channels × samples)
(in memory or loaded on demand) combined with an
[Info](https://martinos.org/mne/stable/generated/mne.Info.html#mne.Info) object (`.info` attribute)
(see `tut_info_objects`).

The most common way to load continuous data is from a .fif file. For more
information on `loading data from other formats <ch_convert>`, or
creating it `from scratch <tut_creating_data_structures>`.





{:.input_area}
```python
import mne
import os.path as op
from matplotlib import pyplot as plt
```


Loading continuous data
-----------------------

Load an example dataset, the preload flag loads the data into memory now:





{:.input_area}
```python
data_path = op.join(mne.datasets.sample.data_path(), 'MEG',
                    'sample', 'sample_audvis_raw.fif')
raw = mne.io.read_raw_fif(data_path, preload=True)
raw.set_eeg_reference('average', projection=True)  # set EEG average reference

# Give the sample rate
print('sample rate:', raw.info['sfreq'], 'Hz')
# Give the size of the data matrix
print('%s channels x %s samples' % (len(raw), len(raw.times)))
```


{:.output .output_stream}
```
Opening raw data file /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sample_audvis_raw.fif...
    Read a total of 3 projection items:
        PCA-v1 (1 x 102)  idle
        PCA-v2 (1 x 102)  idle
        PCA-v3 (1 x 102)  idle
    Range : 25800 ... 192599 =     42.956 ...   320.670 secs
Ready.
Current compensation grade : 0
Reading 0 ... 166799  =      0.000 ...   277.714 secs...
Adding average EEG reference projection.
1 projection items deactivated
Average reference projection was added, but has not been applied yet. Use the apply_proj method to apply it.
sample rate: 600.614990234375 Hz
166800 channels x 166800 samples

```

**Note:**
This size can also be obtained by examining `raw._data.shape`.
However this is a private attribute as its name starts
with an `_`. This suggests that you should **not** access this
variable directly but rely on indexing syntax detailed just below.

Information about the channels contained in the [Raw](https://martinos.org/mne/stable/generated/mne.io.Raw.html)
object is contained in the https://martinos.org/mne/stable/generated/mne.Info.html#mne.Info attribute.
This is essentially a dictionary with a number of relevant fields (see
`tut_info_objects`).



Indexing data
-------------

To access the data stored within :class:`Raw <mne.io.Raw>` objects,
it is possible to index the :class:`Raw <mne.io.Raw>` object.

Indexing a :class:`Raw <mne.io.Raw>` object will return two arrays: an array
of times, as well as the data representing those timepoints. This works
even if the data is not preloaded, in which case the data will be read from
disk when indexing. The syntax is as follows:





{:.input_area}
```python
# Extract data from the first 5 channels, from 1 s to 3 s.
sfreq = raw.info['sfreq']
data, times = raw[:5, int(sfreq * 1):int(sfreq * 3)]
_ = plt.plot(times, data.T)
_ = plt.title('Sample channels')
```



{:.output .output_png}
![png](../images/raw_to_evoked/raw_8_0.png)



Selecting subsets of channels and samples
-----------------------------------------

It is possible to use more intelligent indexing to extract data, using
channel names, types or time ranges.





{:.input_area}
```python
# Pull all MEG gradiometer channels:
# Make sure to use .copy() or it will overwrite the data
meg_only = raw.copy().pick_types(meg=True)
eeg_only = raw.copy().pick_types(meg=False, eeg=True)

# The MEG flag in particular lets you specify a string for more specificity
grad_only = raw.copy().pick_types(meg='grad')

# Or you can use custom channel names
pick_chans = ['MEG 0112', 'MEG 0111', 'MEG 0122', 'MEG 0123']
specific_chans = raw.copy().pick_channels(pick_chans)
print(meg_only)
print(eeg_only)
print(grad_only)
print(specific_chans)
```


{:.output .output_stream}
```
<Raw  |  sample_audvis_raw.fif, n_channels x n_times : 305 x 166800 (277.7 sec), ~391.7 MB, data loaded>
<Raw  |  sample_audvis_raw.fif, n_channels x n_times : 59 x 166800 (277.7 sec), ~78.2 MB, data loaded>
<Raw  |  sample_audvis_raw.fif, n_channels x n_times : 203 x 166800 (277.7 sec), ~261.7 MB, data loaded>
<Raw  |  sample_audvis_raw.fif, n_channels x n_times : 4 x 166800 (277.7 sec), ~8.1 MB, data loaded>

```

Notice the different scalings of these types





{:.input_area}
```python
f, (a1, a2) = plt.subplots(2, 1)
eeg, times = eeg_only[0, :int(sfreq * 2)]
meg, times = meg_only[0, :int(sfreq * 2)]
a1.plot(times, meg[0])
a2.plot(times, eeg[0])
del eeg, meg, meg_only, grad_only, eeg_only, data, specific_chans
```



{:.output .output_png}
![png](../images/raw_to_evoked/raw_12_0.png)



You can restrict the data to a specific time range





{:.input_area}
```python
raw = raw.crop(0, 50)  # in seconds
print('New time range from', raw.times.min(), 's to', raw.times.max(), 's')
```


{:.output .output_stream}
```
New time range from 0.0 s to 50.00041705299622 s

```

And drop channels by name





{:.input_area}
```python
nchan = raw.info['nchan']
raw = raw.drop_channels(['MEG 0241', 'EEG 001'])
print('Number of channels reduced from', nchan, 'to', raw.info['nchan'])
```


{:.output .output_stream}
```
Number of channels reduced from 376 to 374

```

Concatenating  [Raw](https://martinos.org/mne/stable/generated/mne.io.Raw.html) objects
--------------------------------------------------

[Raw](https://martinos.org/mne/stable/generated/mne.io.Raw.html) objects can be concatenated in time by using the
[raw.append](https://martinos.org/mne/dev/generated/mne.io.Raw.html#mne.io.Raw.append) function. For this to work, they must have the same number of channels and their [Info](https://martinos.org/mne/stable/generated/mne.Info.html#mne.Info) structures should be compatible.





{:.input_area}
```python
# Create multiple :class:`Raw <mne.io.RawFIF>` objects
raw1 = raw.copy().crop(0, 10)
raw2 = raw.copy().crop(10, 20)
raw3 = raw.copy().crop(20, 40)

# Concatenate in time (also works without preloading)
raw1.append([raw2, raw3])
print('Time extends from', raw1.times.min(), 's to', raw1.times.max(), 's')
```


{:.output .output_stream}
```
Time extends from 0.0 s to 40.00399655463821 s

```
