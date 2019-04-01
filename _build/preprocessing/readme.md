---
title: 'Preprocessing'
prev_page:
  url: /raw_to_evoked/info
  title: 'Info'
next_page:
  url: /preprocessing/filtering
  title: 'Filtering'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
Preprocessing
-------------

We will be covering the following preprocessing techniques:

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
