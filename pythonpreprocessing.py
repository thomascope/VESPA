# -*- coding: utf-8 -*-
"""
Created on Fri May 16 12:02:31 2014

@author: tc02
"""

import sys
sys.path.append('/imaging/local/software/mne_python/latest_v0.8')
import mne

raw = mne.io.Raw('/imaging/tc02/vespa/preprocess/meg14_0135_vp7/run1_raw_ssst.fif')

events = mne.find_events(raw, stim_channel='STI101', min_duration=0.002)

epochs = mne.Epochs

event_ids = {'Mismatch_4': 2, 'Match_4': 1, 'Mismatch_8': 5, 'Match_8': 4, 'Mismatch_16': 8, 'Match_16': 7};
tmin = -0.5
tmax = 1.5

include = []  # or stim channels ['STI 014']

raw.info['bads'] += ['EEG 030', 'EEG 040', 'MEG 0813','MEG 1731','MEG 1412','MEG 1921' ]  # bads + 1 more

picks = mne.fiff.pick_types(raw.info, meg=False, eeg=True, stim=False, eog=True,
                        include=include, exclude='bads')
                        
epochs = mne.Epochs(raw, events, event_ids, tmin, tmax, picks=picks,
                    baseline=(None, 0), reject=dict(eeg=80e-6, eog=150e-6))
                    
                