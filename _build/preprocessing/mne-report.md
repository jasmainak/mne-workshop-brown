---
interact_link: content/preprocessing/mne-report.ipynb
kernel_name: python3
title: 'Quality assurance'
prev_page:
  url: /preprocessing/readme
  title: 'Preprocessing'
next_page:
  url: /preprocessing/filtering
  title: 'Filtering'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Quality assurance with MNE report

Let's say we want to analyze 100 subjects.

How do we do quality assurancy in a scalable manner?

## MNE report



{:.input_area}
```python
from mne.report import Report
```


A report contains:
    * Figures
    * Images
    * Custom HTML
    * Sliders

First, let us generate some figures for the report.



{:.input_area}
```python
%matplotlib inline

import mne
from mne.datasets import sample

data_path = sample.data_path()
raw_fname = data_path + '/MEG/sample/sample_audvis_raw.fif'
raw = mne.io.read_raw_fif(raw_fname, preload=True)
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

```

Now let's pretend this data came from 3 different subjects



{:.input_area}
```python
raw1 = raw.copy().crop(0, 20)
raw2 = raw.copy().crop(20, 40)
raw3 = raw.copy().crop(40, 60)

raw1.save(data_path + '/MEG/sample/sub-01_raw.fif', overwrite=True)
raw2.save(data_path + '/MEG/sample/sub-02_raw.fif', overwrite=True)
raw3.save(data_path + '/MEG/sample/sub-03_raw.fif', overwrite=True)
```


{:.output .output_stream}
```
Overwriting existing file.
Writing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-01_raw.fif
Closing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-01_raw.fif [done]
Overwriting existing file.
Writing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-02_raw.fif
Closing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-02_raw.fif [done]
Overwriting existing file.
Writing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-03_raw.fif
Closing /home/mainak/Desktop/projects/github_repos/mne-python/examples/MNE-sample-data/MEG/sample/sub-03_raw.fif [done]

```

Now, we can have a function to go from raw to evoked



{:.input_area}
```python
event_id = {'Auditory/Left': 3, 'Auditory/Right': 4}

def raw_to_evoked(raw_fname, tmin=-0.1, tmax=0.5):
    
    raw = mne.io.read_raw_fif(data_path + '/MEG/sample/' + raw_fname, preload=True)
    fig1 = raw.plot();
    raw.filter(0, 40.)
    
    events = mne.find_events(raw, stim_channel='STI 014')
    epochs = mne.Epochs(raw, events, event_id, tmin, tmax)
    fig2 = epochs.plot();
    
    evoked_l = epochs['Left'].average();
    fig3 = evoked_l.plot_topomap()
    fig4 = evoked_l.plot();
    
    return [fig1, fig2, fig3, fig4]
```


Now, we can get all the figure handles:



{:.input_area}
```python
%%capture
figs = raw_to_evoked('sub-01_raw.fif')
```


Now comes the actual report



{:.input_area}
```python
rep = Report()
```


{:.output .output_stream}
```
Embedding : jquery-1.10.2.min.js
Embedding : jquery-ui.min.js
Embedding : bootstrap.min.js
Embedding : jquery-ui.min.css
Embedding : bootstrap.min.css

```



{:.input_area}
```python
captions = ['Raw', 'Epochs', 'Topomap', 'Butterfly']
rep.add_figs_to_section(figs, captions=captions)
rep.save('report_raw_to_evoked.html')
```


{:.output .output_stream}
```
Report already exists at location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_raw_to_evoked.html. Overwrite it (y/[n])? y
Saving report to location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_raw_to_evoked.html
Rendering : Table of Contents
custom
 ... Raw
 ... Epochs
 ... Topomap
 ... Butterfly

```




{:.output .output_data_text}
```
'/home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_raw_to_evoked.html'
```



The report can be found [here](report_raw_to_evoked.html)

We can go even more fancy. Let's try to process all the three subjects.



{:.input_area}
```python
%%capture
rep = Report()
for idx, r in enumerate(['sub-01_raw.fif', 'sub-02_raw.fif', 'sub-03_raw.fif']):
    figs = raw_to_evoked(r)
    rep.add_figs_to_section(figs, captions=captions, section='Subject %02d' % idx)
rep.save('report_raw_to_evoked.html', overwrite=True)
```


There are tabs for each subject!

Parallel processing
-------------------



{:.input_area}
```python
def raw_to_evoked(raw_fname, tmin=-0.1, tmax=0.5):
    raw = mne.io.read_raw_fif(data_path + '/MEG/sample/' + raw_fname, preload=True)
    raw.filter(0, 40.)
    events = mne.find_events(raw, stim_channel='STI 014')
    epochs = mne.Epochs(raw, events, event_id, tmin, tmax)
    evoked_l = epochs['Left'].average();

from mne.parallel import parallel_func

fnames = ['sub-01_raw.fif', 'sub-02_raw.fif', 'sub-03_raw.fif']
parallel, myfunc, _ = parallel_func(raw_to_evoked, n_jobs=3)
parallel(myfunc(fname) for fname in fnames);
```


BEM sliders
-----------

What else can you do? You can inspect quality of the BEM with sliders.



{:.input_area}
```python
subjects_dir = data_path + '/subjects'

rep = Report()
rep.add_bem_to_section(subject='sample', subjects_dir=subjects_dir, decim=36)
rep.save('report_bem.html')
```


{:.output .output_stream}
```
Embedding : jquery-1.10.2.min.js
Embedding : jquery-ui.min.js
Embedding : bootstrap.min.js
Embedding : jquery-ui.min.css
Embedding : bootstrap.min.css
Report already exists at location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_bem.html. Overwrite it (y/[n])? y
Saving report to location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_bem.html
Rendering : Table of Contents
bem
 ... BEM

```




{:.output .output_data_text}
```
'/home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_bem.html'
```



Check out the report [here](report_bem.html)

Custom HTML
--------------------

We can even add custom htmls. For example, we can say:



{:.input_area}
```python
html = """
<table class="table table-hover">
   <tr>
       <th>Meas time range</th>
       <th>Sampling freq</th>
   </tr>
   <tr>
       <td> %0.2f to %0.2f </td>
       <td> %0.2f </td>
   </tr>
</table>
"""
```




{:.input_area}
```python
rep.add_htmls_to_section(html % (raw.times[0], raw.times[-1], raw.info['sfreq']), captions='Info table')
rep.save('report_bem.html', overwrite=True)
```


{:.output .output_stream}
```
Saving report to location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_bem.html
Rendering : Table of Contents
custom
 ... Raw
 ... Epochs
 ... Topomap
 ... Butterfly
 ... Info table

```




{:.output .output_data_text}
```
'/home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_bem.html'
```



Here is the [report](report_bem.html).

Custom sliders
--------------

And we can make our own sliders



{:.input_area}
```python
import matplotlib.pyplot as plt
fname = data_path + '/MEG/sample/sample_audvis-ave.fif'
evoked = mne.read_evokeds(fname, condition='Left Auditory',
                          baseline=(None, 0), verbose=False)

rep = Report()
figs = list()
times = evoked.times[::4]
for time in times:
    figs.append(evoked.plot_topomap(time, vmin=-300, vmax=300,
                                    res=100, show=False))
    plt.close(figs[-1])
rep.add_slider_to_section(figs, times, 'Evoked Response')
rep.save('report_slider.html')
```


{:.output .output_stream}
```
Embedding : jquery-1.10.2.min.js
Embedding : jquery-ui.min.js
Embedding : bootstrap.min.js
Embedding : jquery-ui.min.css
Embedding : bootstrap.min.css
Saving report to location /home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_slider.html
Rendering : Table of Contents
Evoked Response
 ... Evoked Response

```




{:.output .output_data_text}
```
'/home/mainak/Desktop/projects/mne-workshop-brown/content/preprocessing/report_slider.html'
```



To learn more about quality assurance, check out [this paper](https://www.biorxiv.org/content/biorxiv/early/2017/12/28/240044.full.pdf)

Exercise
--------

1) Can you think of creative ways to use the report for your own analysis?

<details>
<summary>
Here are some ideas:<br/><br/>

</summary>
- sections with subject names instead of preprocessing step<br/>
- custom html/javascript to get quality labels<br/>
- sliders to browse through the raw data<br/>
</details>
