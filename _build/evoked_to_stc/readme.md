---
redirect_from:
  - "/evoked-to-stc/readme"
title: 'Evoked to source space'
prev_page:
  url: /preprocessing/ica
  title: 'ICA'
next_page:
  url: /evoked_to_stc/cov
  title: 'Covariance'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
Source modeling
---------------

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
