# Introduction to MNE-Python

Each day is a 1.5 to 2 hours hands-on introduction
to MNE-Python.

Here's a brief break-down of what's coming up:

Day 1: Raw to evoked
--------------------

We will be going from unprocessed continuous data (raw)
to epochs to averaged evoked data. At each
stage, the metadata associated with the recording
can be accessed using an `info` object.

Day 2: Preprocessing
--------------------

_Temporal filtering_: The most basic preprocessing is temporal filtering.
This can remove line noise and high-frequency content.

_Autoreject_: Sometimes, sensors can be bad due to loose contact or
flux jumps. Autoreject is an automated method to label
and repair artifacts in the data.

_Spatial filtering_: Physiological artifacts that are not related to brain
rhythms such as heart beats and eyeblinks have prototypical
spatial signatures. They can be removed using
Signal Space Projection (SSP) or Independant Component
Analysis (ICA).

Day 3: Source modeling
----------------------

The covariance estimation is needed to take into account
the correlated noise in the sensors.

The forward model tells us how a unit dipole on the
cortical surface propagates through the brain. It involves
computation of:

* Boundary element model (BEM) conductivity
of different tissues
* Creation of a discrete source space to compute the forward on the entire
cortical surface
* Coregistration (aligning the head and the device coordinates)

Finally, an inverse operator can be computed and the source
estimation performed.

Buttons
-------

At the top of each notebook, there are two buttons labeled
"Download" and "Interact".

The download button allows you to
save it to disk and run it on your computer. The interact
button is a link to a mybinder instance, so you can play
around with the code in the browser without having to install
anything. Note that it may take a while to load -- sometimes
4 to 5 minutes.
