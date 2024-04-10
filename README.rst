========================================
Timer Generator for Cubing Videos (TGCV)
========================================

About
-----

This repository includes a script to automatically create timers based on the times of a group of solves.
These timers can be overlaid on top of a cubing video using an editing software.

The videos consist of a timer that counts up from 0.00 to the time of the solve. The final time stays displayed for one second.

Usage
-----

Use the `-t` option to specify the times of the solves, separated by commas.

.. code-block:: console
   
   $ ./tgcv.py -t 5.37,5.53,6.06.5.13,6.30
